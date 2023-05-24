# Declare variables that can be used. They do not need to be populated...

variable "name" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "image" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 2
}

variable "custom_data" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "subnet_id" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "load_balancer_address_pool" {
  type = set(string) # Type - not needed, but showing it...
  default = [
  ]
}

variable "sgs" {
  type = set(string) # Type - not needed, but showing it...
  default = [
  ]
}

variable "tags" {
  type = map(any)
  default = {
  }
}
