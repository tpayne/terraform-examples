# Declare variables that can be used. They do not need to be populated...

variable "project" {
  type    = string # Type - not needed, but showing it...
  default = "testdemo"
}

variable "name" {
  type    = string # Type - not needed, but showing it...
  default = "rg_001"
}

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

variable "region_fe" {
  type    = string # Type - not needed, but showing it...
  default = "eu-west-2"
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "eu-west-2"
}

variable "backend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = "10.2.0.0/16"
}

variable "backendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = "10.2.1.0/24"
}

variable "frontend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = "10.1.0.0/16"
}

variable "frontendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = "10.1.1.0/24"
}

variable "backendsn_lb_ip" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "images" {
  type = map(any)
  default = {
    ubunto16 = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
    ubunto18 = "ubuntu/images/hvm-ssd/ubuntu-xenial-18.04-amd64-server-*"
  }
}

variable "machine_types" {
  type = map(any)
  default = {
    micro = "t2.micro"
    dev   = "t2.medium"
    test  = "t2.medium"
    prod  = "t2.xlarge"
  }
}




