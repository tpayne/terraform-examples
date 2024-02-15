// Check test
check "resource_check" {
  assert {
    condition = alltrue([
      var.resourceObj.dbserver-id != null &&
      var.resourceObj.dbproxy-ip != null
    ])
    error_message = "PGSQL Module failed validation"
  }
}

// To error
resource "null_resource" "asserttest" {
  count = (var.assertError) ? 1 : 0
  triggers = alltrue([
    var.resourceObj.dbserver-id != null &&
    var.resourceObj.dbproxy-ip != null
  ]) ? {} : file("PGSQL Module failed validation")

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
