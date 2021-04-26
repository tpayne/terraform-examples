# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started

# This section will declare the providers needed...
# terraform init -upgrade

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.65.0"
    }
  }
}

provider "google" {
  credentials = file(var.creds)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

##############################
# Create network interfaces...
##############################

#------------------------------
# Frontend network resources...
#------------------------------

# Create a frontend VPC network...
resource "google_compute_network" "frontend_vpc_network" {
  name = "${var.project}-vpc-frontend-001"
  auto_create_subnetworks = false
}

# Subnet frontend layer
resource "google_compute_subnetwork" "frontend_subnet" {
  name          = "${var.project}-subnet-frontend-001"
  region        = var.region
  network       = google_compute_network.frontend_vpc_network.name
  ip_cidr_range = "10.1.0.0/24"
}

# Network peering
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering
resource "google_compute_network_peering" "frontend_backend_peering" {
  name         = "${var.project}-frontendpeering-001"
  network      = google_compute_network.frontend_vpc_network.id
  peer_network = google_compute_network.backend_vpc_network.id
}

#------------------------------
# Backend network resources...
#------------------------------

# Create a backend VPC network...
resource "google_compute_network" "backend_vpc_network" {
  name = "${var.project}-vpc-backend-001"
  auto_create_subnetworks = false
}

# Subnet backend layer
resource "google_compute_subnetwork" "backend_subnet" {
  name          = "${var.project}-subnet-backend-001"
  region        = var.region
  network       = google_compute_network.backend_vpc_network.name
  ip_cidr_range = "10.2.0.0/24"
}

# Network peering
resource "google_compute_network_peering" "backendend_frontend_peering" {
  name         = "${var.project}-backendpeering-001"
  network      = google_compute_network.backend_vpc_network.id
  peer_network = google_compute_network.frontend_vpc_network.id
}

resource "google_compute_network_peering" "backendend_databaseend_peering" {
  name         = "${var.project}-backendpeering-002"
  network      = google_compute_network.backend_vpc_network.id
  peer_network = google_compute_network.database_vpc_network.id
}

#------------------------------
# Database network resources...
#------------------------------

# Create a database VPC network...
resource "google_compute_network" "database_vpc_network" {
  name = "${var.project}-vpc-dbase-001"
  auto_create_subnetworks = false
}

# Subnet database layer
resource "google_compute_subnetwork" "database_subnet" {
  name          = "${var.project}-subnet-dbase-001"
  region        = var.region
  network       = google_compute_network.database_vpc_network.name
  ip_cidr_range = "10.3.0.0/24"
}

# Network peering
resource "google_compute_network_peering" "databaseend_backendend_peering" {
  name         = "${var.project}-backendpeering-002"
  network      = google_compute_network.database_vpc_network.id
  peer_network = google_compute_network.backend_vpc_network.id
}

resource "google_compute_global_address" "db_ip_block" {
  name         = "private-db-ip-block"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 20
  network       = google_compute_network.database_vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.database_vpc_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_ip_block.name]
}

resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.database_vpc_network.name
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh-enabled"]
}

##############################
# Create compute resources...
##############################

#------------------------------
# Database compute resources...
#------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance

resource "google_sql_database_instance" "instance" {
  name              = "private-instance-${random_id.random_suffix.hex}"
  region            = var.region
  database_version  = "POSTGRES_13"
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    disk_type         = "PD_HDD"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled = false
      private_network = google_compute_network.database_vpc_network.self_link
    }
  }
}

resource "google_sql_database" "database" {
  name     = "dbase-001"
  instance = google_sql_database_instance.instance.name
}

# Proxy access...
resource "google_service_account" "dbproxy_account" {
  account_id = "dbproxy-account"
}

resource "google_project_iam_member" "dbrole" {
  role   = "roles/cloudsql.editor"
  member = "serviceAccount:${google_service_account.dbproxy_account.email}"
}

resource "google_service_account_key" "dbkey" {
  service_account_id = google_service_account.dbproxy_account.name
}

# Proxy resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

resource "google_compute_instance" "db_proxy" {
  name                      = "db-proxy"
  machine_type              = var.machine_types.dev
  zone                      = var.zone

  desired_status            = "RUNNING"

  allow_stopping_for_update = true

  tags = ["ssh-enabled"]

  boot_disk {
    initialize_params {
      image = var.images.cos 
      size  = 10                
      type  = "pd-standard"             
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = templatefile("${path.module}/run_cloud_sql_proxy.tpl", {
                                      "db_instance_name"    = "db-proxy",
                                      "service_account_key" = base64decode(google_service_account_key.dbkey.private_key),
                            })

  network_interface {
    network    = google_compute_network.database_vpc_network.self_link
    subnetwork = google_compute_subnetwork.database_subnet.self_link 
    access_config {}
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
  }
  service_account {
    email = google_service_account.dbproxy_account.email
    scopes = ["cloud-platform"]
  }
}
