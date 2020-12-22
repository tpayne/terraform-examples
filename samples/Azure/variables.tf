# Declare variables that can be used. They do not need to be populated...

variable "location" {
  default = "westus2"
}

variable "tags" {
  type = map(any)
  default = {
    env  = "development"
    team = "dev"
    proj = "DevOps"
  }
}

variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "Password must meet Azure complexity requirements"
  default     = "ThisIsA.BigPassword-15243"
}

variable "sku" {
  default = {
    westus2 = "16.04-LTS"
    eastus  = "18.04-LTS"
  }
}