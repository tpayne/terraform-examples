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

variable "frontendvpn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backendvpn_cidr_range" {
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
    free     = "Free"
    basic    = "Basic"
    standard = "Standard"
    rapid    = "HighPerformance"
    ultra    = "UltraPerformance"
    westus2  = "16.04-LTS"
    uksouth  = "18.04-LTS"
  }
}

variable "vpn_gen" {
  type = map(any)
  default = {
    gen1 = "Generation1"
    gen2 = "Generation2"
  }
}

variable "vpn_type" {
  type = map(any)
  default = {
    policy = "PolicyBased"
    route  = "RouteBased"
    vnet   = "Vnet2Vnet"
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

variable "vpn_shared_key" {
  type    = string # Type - not needed, but showing it...
  default = "4-v3ry-53cr3t-k3y-t0-u53"
}


