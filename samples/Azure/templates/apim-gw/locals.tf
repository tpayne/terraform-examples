locals {
  allowed-cidrs = "[${local.network-firewall-config.control-cidr}]"

  // APIM config
  apim-config = {
    client_cert_enabled = false
    gw_enabled          = true
    identity_type       = "SystemAssigned"
    min_api_version     = null
    sku_tier            = "Basic_1"
  }

  // network firewall
  network-firewall-config = {
    control-cidr = (var.access_cidr != null && length(var.access_cidr) > 0) ? var.access_cidr : "${data.external.routerip.result["ip"]}/32"
    allow = [
      {
        protocol = "Tcp"
        priority = 1000
        ports    = ["80", "443", "6443", "8080-8085"]
      },
      {
        protocol = "Udp"
        priority = 1001
        ports    = ["1-65535"]
      }
    ]
  }

  tags = {
  }
}
