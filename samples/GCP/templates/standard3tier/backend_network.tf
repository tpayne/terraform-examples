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