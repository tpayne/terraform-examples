# Declare variables that can be used. They do not need to be populated...

variable "project" {}

variable "tags" {
  type = map(any)
  default = {
    env  = "development"
    team = "dev"
  }
}

variable "region_be" {
  # az account list-locations --query [].name
  type    = string # Type - not needed, but showing it...
  default = "uksouth"
}

variable "aks_version" {
  type    = string
  default = "1.19.9"
}

variable "os_disk_size" {
  default     = 30
  type        = number
  description = "Standard OS disk size"
}

variable "aks_nodes_pool_size" {
  default     = 2
  description = "Number of AKS nodes"
}

variable "aks_nodes_pool_maxsize" {
  default     = 8
  description = "Number of AKS max nodes"
}

variable "access_cidr_range" {
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

variable "machine_types" {
  type = map(any)
  default = {
    dev  = "Standard_D2_v2"
    test = "Standard_D2as_v4"
    prod = "Standard_D8s_v3"
  }
}

variable "sku" {
  type = map(any)
  default = {
    free    = "Free"
    westus2 = "16.04-LTS"
    eastus  = "18.04-LTS"
  }
}




