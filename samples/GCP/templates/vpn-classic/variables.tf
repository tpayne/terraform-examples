# Declare variables that can be used. They do not need to be populated...

variable "project" {}
variable "creds" {}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 5
}

variable "region_fe_asn" {
  type    = number # Type - not needed, but showing it...
  default = 64513
}

variable "region_be_asn" {
  type    = number # Type - not needed, but showing it...
  default = 64514
}

variable "region_fe" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1"
}

variable "zone_fe" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1-b"
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1"
}

variable "zone_be" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1-b"
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

variable "secret" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "images" {
  type = map(any)
  default = {
    cos     = "cos-cloud/cos-stable"
    minimal = "cos-cloud/cos-stable"
    deb     = "debian-cloud/debian-9"
    ubunto  = "ubuntu-os-cloud/ubuntu-1804-lts"
  }
}


