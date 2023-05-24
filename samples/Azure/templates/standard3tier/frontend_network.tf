/**
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
# This sample is using modules to create a number of frontend network routers, load balancers etc.
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

##############################
# Create network interfaces...
##############################

resource "azurerm_network_ddos_protection_plan" "ddos" {
  name                = "${var.project}-ddos-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
}

#------------------------------
# Frontend network resources...
#------------------------------

# Create a frontend VNET network...
resource "azurerm_virtual_network" "fevnet" {
  name                = "${var.project}-vnet-frontend-001"
  address_space       = [var.frontend_cidr_range]
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos.id
    enable = true
  }
}

# Subnet frontend layer
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "${var.project}-subnet-frontend-001"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.fevnet.name
  address_prefixes     = [var.frontendsn_cidr_range]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

# Firewall rules
resource "azurerm_network_security_group" "fnsg" {
  name                = "${var.project}-nsg-frontend-001"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = var.frontend_cidr_range
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = var.frontend_cidr_range
  }
}

resource "azurerm_subnet_network_security_group_association" "fensgass001" {
  subnet_id                 = azurerm_subnet.frontend_subnet.id
  network_security_group_id = azurerm_network_security_group.fnsg.id
}

# Load Balancer
locals {
  external_load_balancer_defaults = {
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location            = azurerm_resource_group.resourceGroup.location
    tags                = azurerm_resource_group.resourceGroup.tags
    subnet_id           = azurerm_subnet.frontend_subnet.id
  }
}

module "external-lb" {
  source   = "../modules/external-lb"
  defaults = local.external_load_balancer_defaults
  name     = "${var.project}-frontend-lb"

  load_balancer_rules = [{
    protocol      = "Tcp",
    frontend_port = 80,
    backend_port  = 80
    },
    {
      protocol      = "Tcp",
      frontend_port = 22,
      backend_port  = 22
    }
  ]
}

