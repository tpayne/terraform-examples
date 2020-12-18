# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started

terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "sample_ws"
  ports {
    internal = 80
    external = 8000
  }
}



