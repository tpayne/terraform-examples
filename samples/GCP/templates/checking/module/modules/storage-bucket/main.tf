locals {
  objectCheck = alltrue([
    data.google_storage_bucket.toCheck.storage_class == "STANDARD" &&
    data.google_storage_bucket.toCheck.versioning[0].enabled == true &&
    alltrue([
      for k, v in(var.cmpObj != null) ? var.cmpObj : {} :
      data.google_storage_bucket.toCheck[k] == v
    ])
  ])
}

data "google_storage_bucket" "toCheck" {
  name    = var.resourceObj.name
  project = var.resourceObj.projectId.name
}

// Assert checks
//
check "assertCheck" {
  assert {
    condition = alltrue([
      local.objectCheck
    ])
    error_message = "Bucket ${var.resourceObj.name} failed validation"
  }
}

//
// Error check
//
resource "null_resource" "assertError" {
  count = (var.assertError) ? 1 : 0
  triggers = alltrue([
    local.objectCheck
  ]) ? {} : file("Bucket failed validation")

  lifecycle {
    ignore_changes = [
      triggers
    ]
  }
}
