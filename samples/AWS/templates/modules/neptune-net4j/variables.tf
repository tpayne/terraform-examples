variable "access_cidr" {
  type        = list(string)
  default     = []
  nullable    = true
  description = "(Optional) The accessible CIDR to use"
}

variable "cluster_config" {
  type = object({
    az_list        = optional(list(string), []),
    cluster_name   = string,
    iam_roles_arns = optional(list(string), null),
    kms_key_arn    = optional(string, null),
  })
  description = "Cluster configuration information"
  nullable    = false
}

variable "create_cluster" {
  type        = bool
  description = "Create a Neptune cluster"
  default     = true
}

variable "create_cluster_snapshot" {
  type        = bool
  description = "Create a Neptune cluster snapshot"
  default     = true
}

variable "create_security_group" {
  type        = bool
  description = "Create security group on VPC"
  default     = true
}

variable "cluster_endpoints" {
  description = "(Optional) A map of cluster endpoints to create."
  type = map(object({
    endpoint_type    = string
    static_members   = list(string)
    excluded_members = list(string)
    tags             = map(string)
  }))
  default = {}
}

variable "can_delete" {
  description = "Whether or not the cluster is delete protected"
  type        = bool
  default     = true
}

variable "db_config" {
  type        = string
  description = "The db config to use"
  nullable    = false
  validation {
    condition = (
      contains([
        "dev",
        "prod"
        ],
        var.db_config
      )
    )
    error_message = "The dbconfig specified is not valid"
  }
}

variable "enable_serverless" {
  description = "Whether or not to create a Serverless Neptune cluster"
  type        = bool
  default     = true
}

variable "event_subscriptions" {
  description = <<-EOT
    Map of Neptune event subscriptions with names and SNS topic ARNs
  EOT
  type        = map(string)
  default     = null
}

variable "instance_configs" {
  type = list(object({
    instance_name  = optional(string, null),
    instance_class = optional(string, null),
    az_name        = optional(string, null),
    promotion_tier = optional(number, 0)
  }))
  description = "List of instance details"
  default     = []
  nullable    = false
}

variable "neptune_cluster_parameters" {
  description = "(Optional) A list of Neptune cluster parameter settings"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
  ]
}

variable "neptune_db_parameters" {
  description = "(Optional) A list of Neptune DB parameter settings"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
  ]
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The region to use"
}

variable "role_name" {
  description = "Name for the Neptune IAM role"
  type        = string
  default     = "iam-role-neptune"
}

variable "subnet_ids" {
  description = "(Optional) A list of subnet IDs to associate with the Neptune cluster"
  type        = list(string)
  default     = null
}

variable "tags" {
  default = {
  }
  description = "(Optional) Resource tags to use"
}

variable "vpc_id" {
  description = "(Optional) The VPC ID for the Neptune cluster and security group"
  type        = string
  default     = null
  nullable    = true
}
