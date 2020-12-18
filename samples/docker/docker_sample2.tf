# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started

resource "docker_image" "ubuntu" {
  name         = "ubuntu:latest"
  keep_locally = false
}

resource "docker_container" "ubuntu" {
  image = docker_image.ubuntu.latest
  name  = "sample_os"
}



