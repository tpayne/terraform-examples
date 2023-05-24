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

##############################
# Create Database resources...
##############################

#------------------------------
# Database network resources...
#------------------------------

# Create a database VNET network...
resource "azurerm_virtual_network" "dbvnet" {
  name                = "${var.project}-vnet-database-001"
  address_space       = [var.dbvnet_cidr_range]
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos.id
    enable = true
  }
}

# Subnet database layer
resource "azurerm_subnet" "dbvnet_subnet001" {
  name                                           = "${var.project}-subnet-database-001"
  resource_group_name                            = azurerm_resource_group.resourceGroup.name
  virtual_network_name                           = azurerm_virtual_network.dbvnet.name
  address_prefixes                               = [var.dbvnetsn_cidr_range]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = false
}

# Peering rules
resource "azurerm_virtual_network_peering" "db_peering001" {
  name                         = "${var.project}-dbpeering-001"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  virtual_network_name         = azurerm_virtual_network.dbvnet.name
  remote_virtual_network_id    = azurerm_virtual_network.bevnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "db_peering002" {
  name                         = "${var.project}-dbpeering-002"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  virtual_network_name         = azurerm_virtual_network.bevnet.name
  remote_virtual_network_id    = azurerm_virtual_network.dbvnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

#------------------------------
# Database compute resources...
#------------------------------

# Load Balancer
locals {
  db_load_balancer_defaults = {
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location            = azurerm_resource_group.resourceGroup.location
    tags                = azurerm_resource_group.resourceGroup.tags
    subnet_id           = azurerm_subnet.dbvnet_subnet001.id
  }
}

module "db-internal-lb" {
  source   = "../modules/internal-lb"
  defaults = local.db_load_balancer_defaults
  name     = "${var.project}-db-lb"

  load_balancer_rules = [{
    protocol      = "Tcp",
    frontend_port = 80,
    backend_port  = 80
    },
    {
      protocol      = "Tcp",
      frontend_port = 22,
      backend_port  = 22
    },
    {
      protocol      = "Tcp",
      frontend_port = 5432,
      backend_port  = 5432
    }
  ]
}

module "database" {
  source                     = "../modules/pgdatabase"
  name                       = "${var.project}db001"
  sku                        = "GP_Gen5_4"
  dbversion                  = "11"
  admin_user                 = var.admin_user
  admin_pwd                  = var.admin_pwd
  resource_group             = azurerm_resource_group.resourceGroup.name
  location                   = azurerm_resource_group.resourceGroup.location
  subnet_id                  = azurerm_subnet.dbvnet_subnet001.id
  storage_endpoint           = module.bemig.vmss-storage-endpoint
  storage_accesskey          = module.bemig.vmss-storage-endpoint-accesskey
  image                      = var.images.ubunto18
  machine_type               = var.machine_types.micro
  load_balancer_address_pool = module.db-internal-lb.load_balancer_backend_address_pool.id
  size                       = var.size
}



