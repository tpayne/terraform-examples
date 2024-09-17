locals {
  toCheck = alltrue([
    data.azurerm_mssql_database.toCheck.name == "server-db" &&
    data.azurerm_mssql_database.toCheck.collation == "SQL_Latin1_General_CP1_CI_AS"
  ])
}

data "azurerm_mssql_database" "toCheck" {
  name      = var.resourceObj.name
  server_id = var.resourceObj.server_id
}

// Check test
check "resource_check" {
  assert {
    condition = alltrue([
      local.toCheck
    ])
    error_message = "MSSQL failed validation"
  }
}

// To error
resource "null_resource" "assertError" {
  count = (var.assertError) ? 1 : 0
  triggers = alltrue([
    local.toCheck
  ]) ? {} : file("MSSQL failed validation")

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
