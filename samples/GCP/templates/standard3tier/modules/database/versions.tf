# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

terraform {
  required_providers {
    google = ">= 3.43, <4.0"
  }
}
