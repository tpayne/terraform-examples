variable "access_logs" {
  description = "The access logs to associate the LB with"
  type        = map(string)
  default     = {}
}

variable "assign_dns" {
  description = "Boolean to assign DNS zone or not"
  type        = bool
  default     = true
}

variable "dns_name" {
  description = "The dns name of the LB"
  type        = string
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners or TCP ports for this LB"
  type        = any
  default     = []
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this LB"
  type        = any
  default     = []
}

variable "lb_type" {
  description = "The name of the LB to create"
  type        = string
  default     = "application"
}

variable "name" {
  description = "The name of the LB"
  type        = string
}

variable "private_zone" {
  description = "Private or public zone"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "The security groups(s) to associate the LB with"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "The subnet(s) to associate the LB with"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created."
  type        = any
  default     = []
}

variable "vpc_id" {
  description = "The ID of the VPC to create the LB in"
  type        = string
}

variable "zone_name" {
  description = "The name of the zone to create the LB DNS record in"
  type        = string
}
