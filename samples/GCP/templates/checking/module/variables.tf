variable "objectsToValidate" {
  type = map(object({
    resourceType = string
    resourceObj  = any
    cmpObj       = optional(map(any), null)
  }))
  nullable    = false
  description = <<EOF
  This object specifies the resources to be validated.
  * Resource type is the type of resource to be validated
  * Resource object is the resource to check
  EOF

  validation {
    condition = alltrue([
      for k, v in var.objectsToValidate :
      contains([
        "http-endpoint",
        "github-repo",
        "gcp-project"
      ], v.resourceType)
    ])
    error_message = "A resource type specified is not valid"
  }
}

variable "assertError" {
  type        = bool
  default     = false
  description = "Is the issue fatal?"
}
