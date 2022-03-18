# Declare variables that can be used. They do not need to be populated...

variable "project" {}

variable "tags" {
  type = map(any)
  default = {
    env  = "development"
    team = "dev"
  }
}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 3
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "eu-west-2"
}

variable "onprem_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "onprem_gateway_ip" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "peer_asn" {
  type    = number # Type - not needed, but showing it...
  default = 64513
}

variable "backend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backendsn_lb_ip" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backendvpn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "vpn_shared_key" {
  type      = string # Type - not needed, but showing it...
  default   = "4v3ry53cr3tk3yt0u53"
  sensitive = true
}


