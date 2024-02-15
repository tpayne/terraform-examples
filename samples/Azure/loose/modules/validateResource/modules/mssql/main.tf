// Check test
check "resource_check" {
  data "azurerm_mssql_database" "tocheck" {
    name      = var.resourceObj.name
    server_id = var.resourceObj.server_id
  }

  assert {
    condition = alltrue([
      data.azurerm_mssql_database.tocheck.name == "server-db" &&
      data.azurerm_mssql_database.tocheck.collation == "SQL_Latin1_General_CP1_CI_AS"
    ])
    error_message = "MSSQL failed validation"
  }
}

// To error
data "azurerm_mssql_database" "toFail" {
  name      = var.resourceObj.name
  server_id = var.resourceObj.server_id
}

resource "null_resource" "asserttest" {
  count = (var.assertError) ? 1 : 0
  triggers = alltrue([
    data.azurerm_mssql_database.toFail.name == "server-db" &&
    data.azurerm_mssql_database.toFail.collation == "SQL_Latin1_General_CP1_CI_AS"
  ]) ? {} : file("MSSQL failed validation")

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
