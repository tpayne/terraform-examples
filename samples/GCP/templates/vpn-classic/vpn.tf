/**
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# This section will declare the providers needed...
# terraform init -upgrade
# DEBUG - export TF_LOG=DEBUG

/*

resource "google_compute_ha_vpn_gateway" "frontend_vpn" {
  region  = var.region_fe
  name    = "${var.project}-vpnha-frontend-001"
  network = google_compute_network.frontend_vpc_network.self_link
}

resource "google_compute_ha_vpn_gateway" "backend_vpn" {
  region  = var.region_be
  name    = "${var.project}-vpnha-backend-001"
  network = google_compute_network.backend_vpc_network.self_link
}

resource "google_compute_vpn_tunnel" "frontend_vpn_tnl001" {
  name                            = "${var.project}-fe-vpn-tunnel001"
  region                          = var.region_fe
  vpn_gateway                     = google_compute_ha_vpn_gateway.frontend_vpn.self_link
  peer_gcp_gateway                = google_compute_ha_vpn_gateway.backend_vpn.self_link
  shared_secret                   = var.secret
  router                          = google_compute_router.frontend_router.self_link
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "frontend_vpn_tnl002" {
  name                            = "${var.project}-fe-vpn-tunnel002"
  region                          = var.region_fe
  vpn_gateway                     = google_compute_ha_vpn_gateway.frontend_vpn.self_link
  peer_gcp_gateway                = google_compute_ha_vpn_gateway.backend_vpn.self_link
  shared_secret                   = var.secret
  router                          = google_compute_router.frontend_router.self_link
  vpn_gateway_interface           = 1
}

resource "google_compute_vpn_tunnel" "backend_vpn_tnl001" {
  name                            = "${var.project}-be-vpn-tunnel001"
  region                          = var.region_be
  vpn_gateway                     = google_compute_ha_vpn_gateway.backend_vpn.self_link
  peer_gcp_gateway                = google_compute_ha_vpn_gateway.frontend_vpn.self_link
  shared_secret                   = var.secret
  router                          = google_compute_router.backend_router.self_link
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "backend_vpn_tnl002" {
  name                            = "${var.project}-be-vpn-tunnel002"
  region                          = var.region_be
  vpn_gateway                     = google_compute_ha_vpn_gateway.backend_vpn.self_link
  peer_gcp_gateway                = google_compute_ha_vpn_gateway.frontend_vpn.self_link
  shared_secret                   = var.secret
  router                          = google_compute_router.backend_router.self_link
  vpn_gateway_interface           = 1
}

# Router interfaces...
resource "google_compute_router_interface" "frontend_router_interface001" {
  depends_on = [ google_compute_router.frontend_router ]

  name       = "${var.project}-fe-router001-inter001"
  router     = google_compute_router.frontend_router.name
  region     = var.region_fe
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.frontend_vpn_tnl001.name
}

resource "google_compute_router_interface" "frontend_router_interface002" {
  depends_on = [ google_compute_router.frontend_router ]

  name       = "${var.project}-fe-router001-inter002"
  router     = google_compute_router.frontend_router.name
  region     = var.region_fe
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.frontend_vpn_tnl002.name
}

resource "google_compute_router_interface" "backend_router_interface001" {
  depends_on = [ google_compute_router.backend_router ]

  name       = "${var.project}-be-router001-inter001"
  router     = google_compute_router.backend_router.name
  region     = var.region_be
  ip_range   = "169.254.2.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.backend_vpn_tnl001.name
}

resource "google_compute_router_interface" "backend_router_interface002" {
  depends_on = [ google_compute_router.backend_router ]

  name       = "${var.project}-be-router001-inter002"
  router     = google_compute_router.backend_router.name
  region     = var.region_be
  ip_range   = "169.254.3.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.backend_vpn_tnl002.name
}

# Router peering...
resource "google_compute_router_peer" "frontend_router_peer001" {
  name                      = "${var.project}-fe-router001-peer001"
  router                    = google_compute_router.frontend_router.name
  region                    = var.region_fe
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = var.region_be_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.frontend_router_interface001.name
}

resource "google_compute_router_peer" "frontend_router_peer002" {
  name                      = "${var.project}-fe-router001-peer002"
  router                    = google_compute_router.frontend_router.name
  region                    = var.region_fe
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = var.region_be_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.frontend_router_interface002.name
}

resource "google_compute_router_peer" "backend_router_peer001" {
  name                      = "${var.project}-be-router001-peer001"
  router                    = google_compute_router.backend_router.name
  region                    = var.region_be
  peer_ip_address           = "169.254.2.2"
  peer_asn                  = var.region_fe_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.backend_router_interface001.name
}

resource "google_compute_router_peer" "backend_router_peer002" {
  name                      = "${var.project}-be-router001-peer002"
  router                    = google_compute_router.backend_router.name
  region                    = var.region_be
  peer_ip_address           = "169.254.3.2"
  peer_asn                  = var.region_fe_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.backend_router_interface002.name
}

*/


module "frontend_vpn" {
  depends_on  = [module.cloud-nat-fe.router_name]
  source      = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version     = "~> 1.3.0"
  project_id  = var.project
  network     = google_compute_network.frontend_vpc_network.self_link
  region      = var.region_fe
  name        = "${var.project}-vpnha-frontend-001"
  router_name = module.cloud-nat-fe.router_name
  router_asn  = var.region_fe_asn

  peer_gcp_gateway = module.backend_vpn.self_link

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = var.region_be_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.backend_vpn.random_secret
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = var.region_be_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = module.backend_vpn.random_secret
    }
  }
}

module "backend_vpn" {
  depends_on  = [module.cloud-nat-be.router_name]
  source      = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version     = "~> 1.3.0"
  project_id  = var.project
  network     = google_compute_network.backend_vpc_network.self_link
  region      = var.region_be
  name        = "${var.project}-vpnha-backend-001"
  router_name = module.cloud-nat-be.router_name
  router_asn  = var.region_be_asn

  peer_gcp_gateway = module.frontend_vpn.self_link

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = var.region_fe_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = var.secret
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = var.region_fe_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = var.secret
    }
  }
}



/*
module "frontend_vpn" {
  source             = "terraform-google-modules/vpn/google"
  version            = "~> 1.2.0"
  project_id         = var.project
  network            = google_compute_network.frontend_vpc_network.self_link
  region             = var.region_fe
  gateway_name       = "${var.project}-vpn-frontend-001"
  tunnel_name_prefix = "${var.project}-vpn-frontend-001-tnl-"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = [module.backend_vpn.gateway_ip]
  cr_name            = google_compute_router.frontend_router.name
  cr_enabled         = false
  remote_subnet      = [google_compute_subnetwork.backend_subnet.ip_cidr_range]
}
  

module "backend_vpn" {
  source             = "terraform-google-modules/vpn/google"
  version            = "~> 1.2.0"
  project_id         = var.project
  network            = google_compute_network.backend_vpc_network.self_link
  region             = var.region_be
  gateway_name       = "${var.project}-vpn-backend-001"
  tunnel_name_prefix = "${var.project}-vpn-backend-001-tnl-"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = [module.frontend_vpn.gateway_ip]
  cr_name            = module.cloud-nat.router_name
  cr_enabled         = false
}

*/

