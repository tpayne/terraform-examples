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

resource "google_compute_external_vpn_gateway" "onprem_vpn" {
  name            = "${var.project}-vpngw-onprem-001"
  redundancy_type = "TWO_IPS_REDUNDANCY"
  description     = "An externally managed VPN gateway"

  interface {
    id         = 0
    ip_address = var.onprem_peering_ip001
  }
  interface {
    id         = 1
    ip_address = var.onprem_peering_ip002
  }
}

resource "google_compute_ha_vpn_gateway" "backend_vpn" {
  depends_on = [google_compute_network.backend_vpc_network]
  region     = var.region_be
  name       = "${var.project}-vpnha-backend-001"
  network    = google_compute_network.backend_vpc_network.self_link
}

resource "google_compute_vpn_tunnel" "backend_vpn_tnl001" {
  name                            = "${var.project}-be-vpn-tunnel001"
  project                         = var.project
  region                          = var.region_be
  vpn_gateway                     = google_compute_ha_vpn_gateway.backend_vpn.self_link
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.onprem_vpn.self_link
  peer_external_gateway_interface = 0
  shared_secret                   = var.secret
  router                          = google_compute_router.backend_router.self_link
}

resource "google_compute_vpn_tunnel" "backend_vpn_tnl002" {
  name                            = "${var.project}-be-vpn-tunnel002"
  project                         = var.project
  region                          = var.region_be
  vpn_gateway                     = google_compute_ha_vpn_gateway.backend_vpn.self_link
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.onprem_vpn.self_link
  peer_external_gateway_interface = 0
  shared_secret                   = var.secret
  router                          = google_compute_router.backend_router.self_link
}

