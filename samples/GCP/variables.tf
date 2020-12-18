# Declare variables that can be used. They do not need to be populated...

variable "project" {}
variable "creds" {}

variable "region" {
  type = string # Type - not needed, but showing it...
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "tags" { default = [] }

variable "machine_types" {
  type    = map
  default = {
    dev  = "f1-micro"
    test = "n1-highcpu-32"
    prod = "n1-highcpu-32"
  }
}

variable "images" {
  type    = map
  default = {
    cos  = "cos-cloud/cos-stable"
    deb  = "debian-cloud/debian-9"
  }
}