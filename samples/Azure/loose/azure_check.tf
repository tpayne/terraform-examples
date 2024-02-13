resource "azurerm_resource_group" "checkrg" {
  name     = "checkrg"
  location = "West Europe"
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "checkrg"
  resource_group_name      = azurerm_resource_group.checkrg.name
  location                 = azurerm_resource_group.checkrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "server" {
  name                         = "xdbsqlserver001"
  resource_group_name          = azurerm_resource_group.checkrg.name
  location                     = azurerm_resource_group.checkrg.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "serverdb" {
  name           = "server-db"
  server_id      = azurerm_mssql_server.server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false
  enclave_type   = "VBS"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

/*
check "resource_check" {
  data "azurerm_storage_account" "tocheck" {
    name                = azurerm_storage_account.storageaccount.name
    resource_group_name = azurerm_storage_account.storageaccount.resource_group_name
  }

  assert {
    condition     = data.azurerm_storage_account.tocheck.name == "acheckrg"
    error_message = "Storage account does not exist"
  }
}
*/

module "validatesa" {
  source = "./modules/validateResource"
  objectsToValidate = {
    test1 = {
      resourceType = "storageaccount"
      resourceObj  = azurerm_storage_account.storageaccount
    }
  }
  depends_on = [
    azurerm_storage_account.storageaccount
  ]
}

module "validatemssql" {
  source = "./modules/validateResource"
  objectsToValidate = {
    test1 = {
      resourceType = "mssql"
      resourceObj  = azurerm_mssql_database.serverdb
    }
  }
  depends_on = [
    azurerm_mssql_database.serverdb
  ]
}