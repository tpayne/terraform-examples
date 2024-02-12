// Check test
check "resource_check" {
  data "azurerm_storage_account" "tocheck" {
    name                = var.resourceObj.name
    resource_group_name = var.resourceObj.resource_group_name
  }

  assert {
    condition = alltrue([
      data.azurerm_storage_account.tocheck.name == "checkrg" &&
      data.azurerm_storage_account.tocheck.account_tier == "Standard"
    ])
    error_message = "Storage account failed validation"
  }
}

// To error
data "azurerm_storage_account" "toFail" {
  name                = var.resourceObj.name
  resource_group_name = var.resourceObj.resource_group_name
}

resource "null_resource" "asserttest" {
  triggers = alltrue([
    data.azurerm_storage_account.toFail.name == "checkrg" &&
    data.azurerm_storage_account.toFail.account_tier == "Standard"
  ]) ? {} : file("Storage account failed validation")

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
