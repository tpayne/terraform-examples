resource "azurerm_api_management" "apim" {
  name                = "${var.project}-apim"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  publisher_name      = local.company_name
  publisher_email     = local.email

  client_certificate_enabled = local.apim-config.client_cert_enabled
  gateway_disabled           = !(local.apim-config.gw_enabled)
  min_api_version            = local.apim-config.min_api_version
  zones                      = local.apim-config.zones

  sku_name = local.apim-config.sku_tier

  dynamic "additional_location" {
    for_each = var.additional_location
    content {
      location             = additional_location.value.location
      capacity             = additional_location.value.capacity
      zones                = additional_location.value.zones
      public_ip_address_id = additional_location.value.public_ip_address_id
      dynamic "virtual_network_configuration" {
        for_each = additional_location.value.subnet_id[*]
        content {
          subnet_id = additional_location.value.subnet_id
        }
      }
    }
  }

  dynamic "certificate" {
    for_each = var.certificate_configs
    content {
      encoded_certificate  = certificate.value.encoded_certificate
      certificate_password = certificate.value.certificate_password
      store_name           = certificate.value.store_name
    }
  }

  identity {
    type         = local.apim-config.identity_type
    identity_ids = endswith(local.apim-config.identity_type, "UserAssigned") ? var.identity_ids : null
  }

  dynamic "hostname_configuration" {
    for_each = length(concat(
      var.management_configs,
      var.portal_configs,
      var.dev_portal_configs,
      var.proxy_configs,
    )) == 0 ? [] : ["enabled"]

    content {
      dynamic "management" {
        for_each = var.management_configs
        content {
          host_name                    = management.value.host_name
          key_vault_id                 = management.value.key_vault_id
          certificate                  = management.value.certificate
          certificate_password         = management.value.certificate_password
          negotiate_client_certificate = management.value.negotiate_client_certificate
        }
      }

      dynamic "portal" {
        for_each = var.portal_configs
        content {
          host_name                    = portal.value.host_name
          key_vault_id                 = portal.value.key_vault_id
          certificate                  = portal.value.certificate
          certificate_password         = portal.value.certificate_password
          negotiate_client_certificate = portal.value.negotiate_client_certificate
        }
      }

      dynamic "developer_portal" {
        for_each = var.dev_portal_configs
        content {
          host_name                    = developer_portal.value.host_name
          key_vault_id                 = developer_portal.value.key_vault_id
          certificate                  = developer_portal.value.certificate
          certificate_password         = developer_portal.value.certificate_password
          negotiate_client_certificate = developer_portal.value.negotiate_client_certificate
        }
      }

      dynamic "proxy" {
        for_each = var.proxy_configs
        content {
          host_name                    = proxy.value.host_name
          default_ssl_binding          = proxy.value.default_ssl_binding
          key_vault_id                 = proxy.value.key_vault_id
          certificate                  = proxy.value.certificate
          certificate_password         = proxy.value.certificate_password
          negotiate_client_certificate = proxy.value.negotiate_client_certificate
        }
      }

      dynamic "scm" {
        for_each = var.scm_configs
        content {
          host_name                    = scm.value.host_name
          key_vault_id                 = scm.value.key_vault_id
          certificate                  = scm.value.certificate
          certificate_password         = scm.value.certificate_password
          negotiate_client_certificate = scm.value.negotiate_client_certificate
        }
      }
    }
  }

  notification_sender_email = data.azuread_user.terraform_user.mail

  protocols {
    enable_http2 = var.http2_enabled
  }

  dynamic "security" {
    for_each = var.security_config[*]
    content {
      enable_backend_ssl30  = security.value.enable_backend_ssl30
      enable_backend_tls10  = security.value.enable_backend_tls10
      enable_backend_tls11  = security.value.enable_backend_tls11
      enable_frontend_ssl30 = security.value.enable_frontend_ssl30
      enable_frontend_tls10 = security.value.enable_frontend_tls10
      enable_frontend_tls11 = security.value.enable_frontend_tls11

      tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled
      tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled
      tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = security.value.tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled
      tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = security.value.tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled
      tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = security.value.tls_rsa_with_aes128_cbc_sha256_ciphers_enabled
      tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = security.value.tls_rsa_with_aes128_cbc_sha_ciphers_enabled
      tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = security.value.tls_rsa_with_aes128_gcm_sha256_ciphers_enabled
      tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = security.value.tls_rsa_with_aes256_cbc_sha256_ciphers_enabled
      tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = security.value.tls_rsa_with_aes256_cbc_sha_ciphers_enabled

      triple_des_ciphers_enabled = security.value.triple_des_ciphers_enabled
    }
  }

  dynamic "sign_in" {
    for_each = var.sign_in ? ["enabled"] : []
    content {
      enabled = var.sign_in
    }
  }

  virtual_network_type = var.vnet_type

  dynamic "virtual_network_configuration" {
    for_each = toset(var.vnet_config)
    content {
      subnet_id = vnet_config.value
    }
  }

  tags = merge(local.tags, var.tags)
}
