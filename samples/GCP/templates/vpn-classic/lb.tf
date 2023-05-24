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

# This module is a modified form of a published GCP GCE module for internal lb that did not work
# This local module fixes those issues.

module "interal-lb" {
  source = "../modules/internal-lb"

  region = var.region_be
  name   = "${var.project}-backend-lb"
  ports  = ["22", "80"]

  network    = google_compute_network.backend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.backend_subnet.self_link

  # global_access = true

  health_check = {
    type                = "http"
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    response            = null
    proxy_header        = null
    port                = 80
    port_name           = null
    request             = null
    request_path        = null
    host                = null
  }

  source_tags = [
    "be-ingress",
    "fe-ingress"
  ]

  target_tags = [
    google_compute_subnetwork.backend_subnet.name,
    module.cloud-nat-be.router_name,
    google_compute_network.backend_vpc_network.name
  ]

  backends = [
    { group = module.backend-mig-001.instance_group, description = "" }
  ]
}


