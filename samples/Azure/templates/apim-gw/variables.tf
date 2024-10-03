variable "project" {
  type        = string
  description = "The name of the project to use"
}

variable "region" {
  type        = string
  default     = "ukwest"
  description = "The region to use"
}

variable "access_cidr" {
  type        = string
  default     = ""
  nullable    = true
  description = "The accessible CIDR to use"
}

variable "network_cidr" {
  type        = string
  default     = ""
  description = "The network CIDR to use"
}

variable "security_config" {
  description = "Security configuration block."
  type = object({
    enable_backend_ssl30  = optional(bool, false)
    enable_backend_tls10  = optional(bool, false)
    enable_backend_tls11  = optional(bool, false)
    enable_frontend_ssl30 = optional(bool, false)
    enable_frontend_tls10 = optional(bool, false)
    enable_frontend_tls11 = optional(bool, false)

    tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = optional(bool, false)
    tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = optional(bool, false)
    tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = optional(bool, false)
    tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = optional(bool, false)
    tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = optional(bool, false)
    tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = optional(bool, false)
    tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = optional(bool, false)
    tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = optional(bool, false)
    tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = optional(bool, false)

    triple_des_ciphers_enabled = optional(bool, false)
  })
  default = {}
}

variable "sign_in" {
  description = "Is sign in enabled?"
  type        = bool
  default     = false
}

variable "identity_ids" {
  description = "A list of IDs for User Assigned Managed Identity resources to be assigned. This is required when type is set to `UserAssigned` or `SystemAssigned, UserAssigned`."
  type        = list(string)
  default     = []
}

variable "additional_location" {
  description = "List of the Azure Region in which the API Management Service should be expanded to."
  type = list(object({
    location             = string
    capacity             = optional(number)
    zones                = optional(list(number), [1, 2, 3])
    public_ip_address_id = optional(string)
    subnet_id            = optional(string)
  }))
  default  = []
  nullable = false
}

variable "certificate_configs" {
  description = "List of certificate configurations."
  type = list(object({
    encoded_certificate  = string
    certificate_password = optional(string)
    store_name           = string
  }))
  default  = []
  nullable = false

  validation {
    condition     = alltrue([for cert in var.certificate_configs : contains(["Root", "CertificateAuthority"], cert.store_name)])
    error_message = "Possible values are `CertificateAuthority` and `Root` for 'store_name' attribute."
  }
}

variable "http2_enabled" {
  description = "Is HTTP2enabled?"
  type        = bool
  default     = false
}

variable "portal_configs" {
  description = "Legacy Portal configurations."
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    certificate                  = optional(string)
    certificate_password         = optional(string)
    negotiate_client_certificate = optional(bool, false)
  }))
  default  = []
  nullable = false
}

variable "management_configs" {
  description = "List of management configurations."
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    certificate                  = optional(string)
    certificate_password         = optional(string)
    negotiate_client_certificate = optional(bool, false)
  }))
  default  = []
  nullable = false
}

variable "dev_portal_configs" {
  description = "Developer Portal configurations."
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    certificate                  = optional(string)
    certificate_password         = optional(string)
    negotiate_client_certificate = optional(bool, false)
  }))
  default  = []
  nullable = false
}

variable "proxy_configs" {
  description = "List of proxy configurations."
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    certificate                  = optional(string)
    certificate_password         = optional(string)
    negotiate_client_certificate = optional(bool, false)
  }))
  default  = []
  nullable = false
}

variable "scm_configs" {
  description = "List of SCM configurations."
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    certificate                  = optional(string)
    certificate_password         = optional(string)
    negotiate_client_certificate = optional(bool, false)
  }))
  default  = []
  nullable = false
}

variable "vnet_type" {
  description = "The type of virtual network you want to use, valid values include: None, External, Internal."
  type        = string
  default     = null

  validation {
    condition     = (var.vnet_type != null) ? contains(["None", "External", "Internal"], var.vnet_type) : true
    error_message = "Invalid type"
  }
}

variable "vnet_config" {
  description = "The id(s) of the subnet(s) that will be used for the API Management. Required when virtual_network_type is External or Internal"
  type        = list(string)
  default     = []
}

variable "tags" {
  default = {
  }
  description = "Project tags"
}
