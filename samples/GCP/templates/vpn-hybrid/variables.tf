# Declare variables that can be used. They do not need to be populated...

variable "project" {}
variable "creds" {}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 5
}

variable "peer_asn" {
  type    = number # Type - not needed, but showing it...
  default = 64513
}

variable "be_asn" {
  type    = number # Type - not needed, but showing it...
  default = 64514
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1"
}

variable "zone_be" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1-b"
}

variable "backend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "onprem_peering_ip001" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "onprem_peering_ip002" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backend_iprange001" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backend_iprange002" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backend_routerpeer_ipaddr001" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backend_routerpeer_ipaddr002" {
  type    = string # Type - not needed, but showing it...
  default = ""
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
  default = "HelloThisIsASecret"
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


