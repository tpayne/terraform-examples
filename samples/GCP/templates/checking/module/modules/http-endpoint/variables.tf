variable "assertError" {
  type        = bool
  default     = false
  description = "Is this check fatal?"
}

variable "resourceObj" {
  type        = any
  nullable    = false
  description = "The resource to validate"
}

