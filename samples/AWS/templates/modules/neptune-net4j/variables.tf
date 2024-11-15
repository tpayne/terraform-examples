variable "access_cidr" {
  type        = string
  default     = ""
  nullable    = true
  description = "(Optional) The accessible CIDR to use"
}

variable "create_cluster" {
  type        = bool
  description = "Create a Neptune cluster"
  default     = true
}

variable "create_instance" {
  type        = bool
  description = "Create a Neptune DB instance"
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

variable "cluster_name" {
  type        = string
  description = "The cluster name to use"
  nullable    = false
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

variable "kms_key_arn" {
  type        = string
  description = "(Optional) The ARN for the KMS encryption key. When specifying kms_key_arn, storage_encrypted needs to be set to true."
  default     = null
}

variable "iam_roles" {
  description = "(Optional) A List of ARNs for the IAM roles to associate to the Neptune Cluster"
  type        = list(string)
  default     = null
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
