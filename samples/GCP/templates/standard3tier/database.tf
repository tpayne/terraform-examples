# This sample is using modules to create a number of backend database resources.
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

##############################
# Create Database resources...
##############################

#------------------------------
# Database network resources...
#------------------------------

# Create a database VPC network...
resource "google_compute_network" "database_vpc_network" {
  name                    = "${var.project}-vpc-dbase-001"
  auto_create_subnetworks = false
}

# Subnet database layer
resource "google_compute_subnetwork" "database_subnet" {
  name                     = "${var.project}-subnet-dbase-001"
  region                   = var.region
  network                  = google_compute_network.database_vpc_network.name
  ip_cidr_range            = "10.6.0.0/24"
  private_ip_google_access = true
}

#------------------------------
# Database compute resources...
#------------------------------

module "database" {
  source       = "./modules/database"
  name         = "dbinstance001"
  dbtype       = var.database_type.postgres
  region       = var.region
  zone         = var.zone1
  machine_type = var.machine_types.dev
  ports        = ["22", "5432"]
  network      = google_compute_network.database_vpc_network.self_link
  subnetwork   = google_compute_subnetwork.database_subnet.self_link
}