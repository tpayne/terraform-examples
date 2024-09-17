locals {
}

// Assert checks
//
check "projectAssertCheck" {
  data "google_project" "toCheck" {
    project_id = var.resourceObj.projectId.name
  }

  assert {
    condition = alltrue([
      data.google_project.toCheck.number != null
    ])
    error_message = "Project ${var.resourceObj.projectId.name} failed validation"
  }
}

//
// Error check
//
data "google_project" "toError" {
  count      = (var.assertError) ? 1 : 0
  project_id = var.resourceObj.projectId.name

  lifecycle {
    postcondition {
      condition = alltrue([
        self.number != null
      ])
      error_message = "Project ${var.resourceObj.projectId.name} failed validation"
    }
  }
}

// Validate other inputs
module "validateSubURL" {
  count       = (var.resourceObj.projectId.url != null) ? 1 : 0
  source      = "../http-endpoint"
  resourceObj = var.resourceObj.projectId.url
  assertError = var.assertError
}

module "validateRoles" {
  count       = (var.resourceObj.projectId.roles != null) ? 1 : 0
  source      = "./gcp-project-roles"
  resourceObj = var.resourceObj
  assertError = var.assertError
}
