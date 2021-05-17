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

# This section will declare the providers needed...
# terraform init -upgrade
# DEBUG - export TF_LOG=DEBUG

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

# Create a frontend VPC network...
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

#------------------------------
# Backend network resources...
#------------------------------

# Create a backend virtual network...
resource "azurerm_virtual_network" "bevnet" {
  name                = "${var.project}-vnet-backend-001"
  address_space       = [var.backend_cidr_range]
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos.id
    enable = true
  }
}

# Subnet backend layer
resource "azurerm_subnet" "backend_subnet" {
  name                 = "${var.project}-subnet-backend-001"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.bevnet.name
  address_prefixes     = [var.backendsn_cidr_range]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

# Firewall rules
resource "azurerm_network_security_group" "bnsg" {
  name                = "${var.project}-nsg-backend-001"
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
    destination_address_prefix = var.backend_cidr_range
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
    destination_address_prefix = var.backend_cidr_range
  }
}

resource "azurerm_subnet_network_security_group_association" "bensgass001" {
  subnet_id                 = azurerm_subnet.backend_subnet.id
  network_security_group_id = azurerm_network_security_group.bnsg.id
}

# Peering rules
resource "azurerm_virtual_network_peering" "frontend_backend_peering" {
  name                         = "${var.project}-frontendpeering-001"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  virtual_network_name         = azurerm_virtual_network.fevnet.name
  remote_virtual_network_id    = azurerm_virtual_network.bevnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "backend_frontend_peering" {
  name                         = "${var.project}-backendpeering-001"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  virtual_network_name         = azurerm_virtual_network.bevnet.name
  remote_virtual_network_id    = azurerm_virtual_network.fevnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}


