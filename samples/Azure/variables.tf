# Declare variables that can be used. They do not need to be populated...

variable "location" {
  default = "westus2"
}

variable "tags" { 
  type    = map
  default = {
    env  = "development"
    team = "dev"
    proj = "DevOps"
  }
}

variable "admin_username" {
  type = string
  description = "Administrator user name for virtual machine"
  default = "azureadmin"
}

variable "admin_password" {
  type = string
  description = "Password must meet Azure complexity requirements"
  default = "ThisIsA.BigPassword-15243"
}
