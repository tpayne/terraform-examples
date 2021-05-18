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
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "vm01" {
  ami           = "ami-830c94e3"
  instance_type = var.machine_types.dev
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.vm01.id
}
