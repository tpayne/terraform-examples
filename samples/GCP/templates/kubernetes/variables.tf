# Declare variables that can be used. They do not need to be populated...

variable "project" {}
variable "creds" {}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1"
}

variable "zone_be" {
  type    = string # Type - not needed, but showing it...
  default = "us-central1-b"
}

variable "gke_version" {
  type    = string
  default = "1.19.9-gke.1400"
}

variable "gke_nodes_pool_size" {
  default     = 1
  description = "Number of GKE nodes"
}

variable "access_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backend_cidr_range" {
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

variable "images" {
  type = map(any)
  default = {
    cos              = "cos-cloud/cos-stable"
    minimal          = "cos-cloud/cos-stable"
    deb              = "debian-cloud/debian-9"
    ubunto           = "ubuntu-os-cloud/ubuntu-1804-lts"
    ubunto_container = "ubuntu_containerd"
  }
}


