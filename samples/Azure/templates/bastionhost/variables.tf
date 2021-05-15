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
  default = "uksouth"
}

variable "backend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "frontend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "frontendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "machine_types" {
  type = map(any)
  default = {
    micro = "Standard_B1ls"
    dev   = "Standard_D2_v2"
    test  = "Standard_D2as_v4"
    prod  = "Standard_D8s_v3"
  }
}

variable "sku_storage" {
  type = map(any)
  default = {
    localrs = "Standard_LRS"
  }
}

variable "sku" {
  type = map(any)
  default = {
    free    = "Free"
    westus2 = "16.04-LTS"
    uksouth = "18.04-LTS"
  }
}

variable "admin_user" {
  type    = string # Type - not needed, but showing it...
  default = "azureuser"
}

variable "admin_pwd" {
  type    = string # Type - not needed, but showing it...
  default = "ThisIsNotAStrongPassword-123"
}



