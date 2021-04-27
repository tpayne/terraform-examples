# Declare variables that can be used. They do not need to be populated...

variable "project" {}
variable "creds" {}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 5
}

variable "region" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1"
}

variable "region_bck" {
  type    = string # Type - not needed, but showing it...
  default = "us-west1"
}

variable "zone1" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1-b"
}

variable "zone2" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1-c"
}

variable "tags" { default = [] }

variable "machine_types" {
  type = map(any)
  default = {
    dev  = "f1-micro"
    test = "n1-highcpu-32"
    prod = "n1-standard-1"
  }
}

variable "images" {
  type = map(any)
  default = {
    cos    = "cos-cloud/cos-stable"
    deb    = "debian-cloud/debian-9"
    ubunto = "ubuntu-os-cloud/ubuntu-1804-lts"
  }
}