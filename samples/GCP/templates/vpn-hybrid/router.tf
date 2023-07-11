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

# Backend router
resource "google_compute_router" "backend_router" {
  name    = "${var.project}-router-backend-001"
  network = google_compute_network.backend_vpc_network.self_link
  region  = var.region_be

  # We do not have a BGP ASN no. assigned to us, so have to use static...
  bgp {
    asn = var.be_asn
  }
}

# NAT router
module "cloud-nat-be" {
  source     = "terraform-google-modules/cloud-nat/google"
  name       = "${var.project}-cloud-nat-backend-001"
  version    = "4.1.0"
  router     = google_compute_router.backend_router.name
  project_id = var.project
  region     = var.region_be
}

# Router interfaces...
resource "google_compute_router_interface" "backend_router_interface001" {
  depends_on = [google_compute_router.backend_router]
  project    = var.project

  name       = "${var.project}-be-router001-inter001"
  router     = google_compute_router.backend_router.name
  region     = var.region_be
  ip_range   = var.backend_iprange001
  vpn_tunnel = google_compute_vpn_tunnel.backend_vpn_tnl001.name
}

resource "google_compute_router_interface" "backend_router_interface002" {
  depends_on = [google_compute_router.backend_router]
  project    = var.project

  name       = "${var.project}-be-router001-inter002"
  router     = google_compute_router.backend_router.name
  region     = var.region_be
  ip_range   = var.backend_iprange002
  vpn_tunnel = google_compute_vpn_tunnel.backend_vpn_tnl002.name
}

# Router peering...
resource "google_compute_router_peer" "backend_router_peer001" {
  depends_on = [google_compute_router.backend_router]

  name                      = "${var.project}-be-router001-peer001"
  router                    = google_compute_router.backend_router.name
  region                    = var.region_be
  peer_ip_address           = var.backend_routerpeer_ipaddr001
  peer_asn                  = var.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.backend_router_interface001.name
}

resource "google_compute_router_peer" "backend_router_peer002" {
  depends_on = [google_compute_router.backend_router]

  name                      = "${var.project}-be-router001-peer002"
  router                    = google_compute_router.backend_router.name
  region                    = var.region_be
  peer_ip_address           = var.backend_routerpeer_ipaddr002
  peer_asn                  = var.peer_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.backend_router_interface002.name
}



