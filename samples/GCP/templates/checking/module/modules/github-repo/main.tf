locals {
}

// Assert checks
//
check "assertCheckGHRepo" {
  data "github_repository" "toCheckGHRepo" {
    full_name = var.resourceObj.gitUrl
  }

  assert {
    condition = alltrue([
      data.github_repository.toCheckGHRepo.git_clone_url != null &&
      data.github_repository.toCheckGHRepo.visibility != "public" &&
      data.github_repository.toCheckGHRepo.private == true
    ])
    error_message = "GH repo ${var.resourceObj.gitUrl} failed validation"
  }
}

//
// Error check
//
data "github_repository" "toErrorGHRepo" {
  count     = (var.assertError) ? 1 : 0
  full_name = var.resourceObj.gitUrl

  lifecycle {
    postcondition {
      condition = alltrue([
        self.git_clone_url != null &&
        self.visibility != "public" &&
        self.private == true
      ])
      error_message = "GH repo ${var.resourceObj.gitUrl} failed validation"
    }
  }
}
