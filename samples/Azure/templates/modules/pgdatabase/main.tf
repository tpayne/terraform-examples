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
# Database compute resources...
#------------------------------
resource "azurerm_postgresql_server" "dbserver" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  administrator_login          = var.admin_user
  administrator_login_password = var.admin_pwd

  sku_name         = var.sku
  version          = var.dbversion

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  identity {
    type = "SystemAssigned"
  }

  threat_detection_policy {
    enabled = true
    storage_endpoint = var.storage_endpoint
    storage_account_access_key = var.storage_accesskey
  }

  tags = var.tags
}

resource "azurerm_postgresql_database" "dbs" {
  name                = "${var.name}dbs"
  resource_group_name = var.resource_group
  server_name         = azurerm_postgresql_server.dbserver.name
  charset             = var.dbcharset
  collation           = var.dbcollation
}

resource "azurerm_private_endpoint" "dbspep" {
  name                = "${var.name}pep"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "pgdbspep"
    private_connection_resource_id = azurerm_postgresql_server.dbserver.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}

#------------------------------
# Database network resources...
#------------------------------
/*
resource "azurerm_postgresql_firewall_rule" "firewall_rules" {
  name                = "${var.name}fwr"
  resource_group_name = var.resource_group
  server_name         = azurerm_postgresql_server.dbserver.name
  start_ip_address    = var.start_ip
  end_ip_address      = var.end_ip
}

resource "azurerm_postgresql_virtual_network_rule" "vnet" {
  name                                 = "postgresql-vnet-rule"
  resource_group_name                  = var.resource_group
  server_name                          = azurerm_postgresql_server.dbserver.name
  subnet_id                            = var.subnet_id
  ignore_missing_vnet_service_endpoint = true
}
*/


