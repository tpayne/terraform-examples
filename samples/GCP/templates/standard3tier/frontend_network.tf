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
  ip_cidr_range            = "10.1.0.0/24"
  private_ip_google_access = true
}

# Subnet frontend layer
resource "google_compute_subnetwork" "frontend_subnet_bck" {
  name                     = "${var.project}-subnet-frontend-002"
  region                   = var.region_bck
  network                  = google_compute_network.frontend_vpc_network.name
  ip_cidr_range            = "10.2.0.0/24"
  private_ip_google_access = true
}

# Frontend router
resource "google_compute_router" "frontend_router" {
  name    = "${var.project}-http-router-frontend-001"
  network = google_compute_network.frontend_vpc_network.self_link
  region  = var.region
}

# NAT router
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  name       = "${var.project}-cloud-nat-lb-http-router-frontend-001"
  version    = "1.4.0"
  router     = google_compute_router.frontend_router.name
  project_id = var.project
  region     = var.region
}

# Load Balancer
module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 4.4"

  name    = "${var.project}-frontend-group-http-lb"
  project = var.project

  target_tags       = [google_compute_network.frontend_vpc_network.name]
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