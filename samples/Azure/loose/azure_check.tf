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
