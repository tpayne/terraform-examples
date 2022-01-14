# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started

# This section will declare the providers needed...
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
  /*
  # https://www.terraform.io/language/settings/backends/s3
  backend "s3" {
    bucket = "bucknetname"
    key    = "path/to/my/statefile"
    region = var.region
  } 
  */
}

provider "aws" {
  profile = "default"
  region  = var.region
}


