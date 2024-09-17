terraform {
  required_version = "~> 1.9.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.3.0"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = ">= 1.1.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.34.0"
    }
  }
}