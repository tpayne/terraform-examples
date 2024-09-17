locals {
}

// Assert checks
//
check "projectPolicyCheck" {
  data "google_project_iam_policy" "toCheck" {
    project = var.resourceObj.projectId.name
  }

  assert {
    condition = alltrue([
      length([
        for e in jsondecode(data.google_project_iam_policy.toCheck.policy_data)["bindings"] :
        e.role if contains(var.resourceObj.projectId.roles, e.role)
      ]) == length(var.resourceObj.projectId.roles)
    ])
    error_message = "Project ${var.resourceObj.projectId.name} failed validation"
  }
}

//
// Error check
//
data "google_project_iam_policy" "toError" {
  count   = (var.assertError) ? 1 : 0
  project = var.resourceObj.projectId.name

  lifecycle {
    postcondition {
      condition = alltrue([
        length([
          for e in jsondecode(self.policy_data)["bindings"] :
          e.role if contains(var.resourceObj.projectId.roles, e.role)
        ]) == length(var.resourceObj.projectId.roles)
      ])
      error_message = "Project ${var.resourceObj.projectId.name} failed validation"
    }
  }
}
