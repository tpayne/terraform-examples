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

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "uksouth"
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

variable "images" {
  type = map(any)
  default = {
    ubunto16 = "ubuntu1604"
    ubunto18 = "ubuntu1804"
    centos   = "centos8"
    coreos   = "coreos"
    win2012  = "windows2012r2dc"
    win2016  = "windows2016dc"
    win2019  = "windows2019dc"
    mssql    = "mssql2017exp"
  }
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



