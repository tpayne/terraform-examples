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

# Frontend router
resource "google_compute_router" "frontend_router" {
  name    = "${var.project}-router-frontend-001"
  network = google_compute_network.frontend_vpc_network.self_link
  region  = var.region_fe

  # We do not have a BGP ASN no. assigned to us, so have to use static...
  bgp {
    asn = var.region_fe_asn
  }
}

# Backend router
resource "google_compute_router" "backend_router" {
  name    = "${var.project}-router-backend-001"
  network = google_compute_network.backend_vpc_network.self_link
  region  = var.region_be

  # We do not have a BGP ASN no. assigned to us, so have to use static...
  bgp {
    asn = var.region_be_asn
  }
}

# NAT router
module "cloud-nat-fe" {
  source     = "terraform-google-modules/cloud-nat/google"
  name       = "${var.project}-cloud-nat-frontend-001"
  version    = "2.2.2"
  router     = google_compute_router.frontend_router.name
  project_id = var.project
  region     = var.region_fe
}

module "cloud-nat-be" {
  source     = "terraform-google-modules/cloud-nat/google"
  name       = "${var.project}-cloud-nat-backend-001"
  version    = "2.2.2"
  router     = google_compute_router.backend_router.name
  project_id = var.project
  region     = var.region_be
}

