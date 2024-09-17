module "validateHttp" {
  source      = "./module"
  assertError = true
  objectsToValidate = {
    toWork = {
      resourceType = "http-endpoint"
      resourceObj  = "https://www.google.com"
    }
    toFail = {
      resourceType = "http-endpoint"
      resourceObj  = "https://www.nothingexistsapi.comx"
    }
  }
}

module "validateGH" {
  source      = "./module"
  assertError = true
  objectsToValidate = {
    toWork = {
      resourceType = "github-repo"
      resourceObj = {
        gitUrl = "tpayne/Training"
      }
    }
    toFail = {
      resourceType = "github-repo"
      resourceObj = {
        gitUrl = "tpayne/kubernetes-examples"
      }
    }
  }
}

module "validateProject" {
  source      = "./module"
  assertError = true
  objectsToValidate = {
    toFail = {
      resourceType = "gcp-project"
      resourceObj = {
        projectId = {
          name = "something"
          no   = 001
          url  = "https://www.nothingexists.api"
          roles = [
            "roles/project.owner",
            "roles/project.viewer"
          ]
        }
      }
    }
  }
}