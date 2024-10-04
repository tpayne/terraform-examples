variable "apiDefs" {
  description = "Map of API definitions to upload"
  type = map(object({
    protocol       = optional(list(string), ["http"])
    content_format = optional(string, "openapi")
    path           = string
  }))
  default = {
  }
}

variable "apim_name" {
  description = "Resource group name"
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  nullable    = false
}