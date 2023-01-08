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

module "frontend_vpn" {
  depends_on  = [module.cloud-nat-fe.router_name]
  source      = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version     = "~> 2.3.0"
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
  version     = "~> 2.3.0"
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
  version            = "~> 2.3.0"
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
  version            = "~> 2.3.0"
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

