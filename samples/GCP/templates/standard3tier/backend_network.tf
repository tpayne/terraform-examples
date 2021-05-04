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
# This sample is using modules to create a number of backend network resources etc.
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

##############################
# Create network interfaces...
##############################
# https://github.com/terraform-google-modules/terraform-google-lb-internal

#------------------------------
# Backend network resources...
#------------------------------

# Create a backend VPC network...
resource "google_compute_network" "backend_vpc_network" {
  name                    = "${var.project}-vpc-backend-001"
  auto_create_subnetworks = false
}

# Subnet backend layer
resource "google_compute_subnetwork" "backend_subnet" {
  name                     = "${var.project}-subnet-backend-001"
  region                   = var.region
  network                  = google_compute_network.backend_vpc_network.name
  ip_cidr_range            = "10.3.0.0/24"
  private_ip_google_access = true
}

# This module is a modified form of a published GCP GCE module for internal lb that did not work
# This local modeul fixes those issues.
module "interal-lb" {
  source = "./modules/interal-lb"

  region = var.region
  name   = "${var.project}-backend-lb"
  ports  = ["5432", "22"]

  network    = google_compute_network.backend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.backend_subnet.self_link

  health_check = {
    type                = "tcp"
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    response            = null
    proxy_header        = null
    port                = 5432
    port_name           = null
    request             = null
    request_path        = null
    host                = null
  }

  source_tags = [google_compute_network.backend_vpc_network.name]
  target_tags = [google_compute_network.backend_vpc_network.name]

  backends = [
    { group = module.backend-mig-001.instance_group, description = "" }
  ]
}


