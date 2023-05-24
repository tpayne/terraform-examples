# Declare variables that can be used. They do not need to be populated...
#

variable "name" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "region_be" {
  type    = string # Type - not needed, but showing it...
  default = "uksouth"
}

variable "tags" {
  type = map(any)
  default = {
    env  = "development"
    team = "dev"
  }
}
