# Declare variables that can be used. They do not need to be populated...

variable "project" {
  type    = string # Type - not needed, but showing it...
  default = "testdemo"
}

variable "tags" {
  type = map(any)
  default = {
    env  = "development"
    team = "dev"
  }
}


variable "name" {
  type    = string # Type - not needed, but showing it...
  default = "rg_001"
}

variable "region_be" {
  # az account list-locations --query [].name
  type    = string # Type - not needed, but showing it...
  default = "uksouth"
}

# az aks get-versions -l uksouth
variable "aks_version" {
  type    = string
  default = "1.22.2"
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
  default = "10.2.0.0/16"
}

variable "backendsn_cidr_range" {
  type    = string # Type - not needed, but showing it...
  default = "10.2.1.0/24"
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




