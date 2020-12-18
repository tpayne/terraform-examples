# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started

# This section will declare the providers needed...
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  # Enter the credentials file here...
  credentials = file("saauth.json")

  # Replace this project with the name of your project...
  project = "macro-mender-279016"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-sample-network"
}


