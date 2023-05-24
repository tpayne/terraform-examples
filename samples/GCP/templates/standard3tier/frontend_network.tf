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
# This sample is using modules to create a number of frontend network routers, load balancers etc.
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

##############################
# Create network interfaces...
##############################
# https://github.com/terraform-google-modules/terraform-google-lb-http

#------------------------------
# Frontend network resources...
#------------------------------

# Create a frontend VPC network...
resource "google_compute_network" "frontend_vpc_network" {
  name                    = "${var.project}-vpc-frontend-001"
  auto_create_subnetworks = false
}

# Subnet frontend layer
resource "google_compute_subnetwork" "frontend_subnet" {
  name                     = "${var.project}-subnet-frontend-001"
  region                   = var.region
  network                  = google_compute_network.frontend_vpc_network.name
  ip_cidr_range            = var.fesubnet_ip_cidr
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "frontend_subnet_bck" {
  name                     = "${var.project}-subnet-frontend-002"
  region                   = var.region_bck
  network                  = google_compute_network.frontend_vpc_network.name
  ip_cidr_range            = var.fesubnet_bck_ip_cidr
  private_ip_google_access = true
}

# Frontend router
resource "google_compute_router" "frontend_router" {
  name    = "${var.project}-http-router-frontend-001"
  network = google_compute_network.frontend_vpc_network.self_link
  region  = var.region
}

resource "google_compute_router" "frontend_router_bck" {
  name    = "${var.project}-http-router-frontend-002"
  network = google_compute_network.frontend_vpc_network.self_link
  region  = var.region_bck
}

# NAT router
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  name       = "${var.project}-cloud-nat-lb-http-router-frontend-001"
  version    = "2.2.1"
  router     = google_compute_router.frontend_router.name
  project_id = var.project
  region     = var.region
}

module "cloud-nat-bck" {
  source     = "terraform-google-modules/cloud-nat/google"
  name       = "${var.project}-cloud-nat-lb-http-router-frontend-002"
  version    = "2.2.1"
  router     = google_compute_router.frontend_router_bck.name
  project_id = var.project
  region     = var.region_bck
}

# Load Balancer
module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 6.0"

  name    = "${var.project}-frontend-group-http-lb"
  project = var.project

  target_tags = [
    google_compute_subnetwork.frontend_subnet.name,
    module.cloud-nat.router_name,
    google_compute_subnetwork.frontend_subnet_bck.name,
    module.cloud-nat-bck.router_name
  ]

  firewall_networks = [google_compute_network.frontend_vpc_network.name]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
      timeout_sec                     = 10
      connection_draining_timeout_sec = null
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable      = false
        sample_rate = null
      }

      groups = [
        {
          group                        = module.frontend-mig-001.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
        {
          group                        = module.frontend-mig-002.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}


