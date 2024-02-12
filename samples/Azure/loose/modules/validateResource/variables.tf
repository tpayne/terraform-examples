variable "objectsToValidate" {
  type = map(object({
    resourceType = string
    resourceObj  = any
  }))
  nullable = false
}