# Declare variables that can be used. They do not need to be populated...

variable "name" {
  type        = string
  description = "Name of the database system to setup"
  default     = "db"
}

variable "network" {
  description = "Name of the network to create resources in."
  default     = ""
}

variable "subnetwork" {
  description = "Name of the subnetwork to create resources in."
  default     = ""
}

variable "region" {
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable "zone" {
  description = "Zone for cloud resources."
  default     = "us-central1-b"
}

variable "dbtype" {
  description = "Database type"
  default     = "POSTGRES_13"
}

variable "tier" {
  description = "Database tier"
  default     = "db-f1-micro"
}

variable "ports" {
  description = "Allowed ports"
  type        = list(any)
  default     = []
}

variable "disk_type" {
  description = "Database disk type"
  default     = "PD_HDD"
}

variable "machine_type" {
  description = "Database machine type"
  default     = "n1-standard-1"
}

variable "machine_image" {
  description = "Database machine image"
  default     = "cos-cloud/cos-stable"
}
