variable "objectsToValidate" {
  type = map(object({
    resourceType = string
    resourceObj  = any
  }))
  nullable = false
}

variable "assertError" {
  type    = bool
  default = true
}