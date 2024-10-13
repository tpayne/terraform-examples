# Declare variables that can be used. They do not need to be populated...

variable "project" {
  type = string
  default = null
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
  default = 2
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "westus2"
}

variable "frontend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "frontendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backend_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "backendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "dbvnet_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "dbvnetsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "start_ip" {
  description = "IP range to allow to connect."
  default     = ""
}

variable "end_ip" {
  description = "IP range to allow to connect."
  default     = ""
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

variable "emailaddr" {
  type    = string
  default = "testemail@noreply.com"
}

# Do we want alerts?
variable "alerts" {
  type    = bool
  default = true # or false
}
