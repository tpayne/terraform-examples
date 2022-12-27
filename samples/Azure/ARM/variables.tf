variable "name" {
  type    = string
  default = ""
}

variable "create_group" {
  type    = bool
  default = true
}

variable "group_name" {
  type    = string
  default = ""
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "uksouth"
}

variable "arm_file" {
  type     = string
  default  = ""
  nullable = false
}

variable "email" {
  type      = string
  default   = ""
  sensitive = true
  nullable  = false
}

variable "tags" {
  type = map(any)
  default = {
    env  = "development"
    team = "dev"
  }
}
