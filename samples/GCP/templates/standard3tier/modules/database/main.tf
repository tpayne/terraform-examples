# This sample is using modules to create a number of backend database resources.
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

##############################
# Create Database resources...
##############################

resource "random_id" "random_suffix" {
  byte_length = 4
}

resource "google_compute_global_address" "db_ip_block" {
  name          = "${var.name}-ip-block"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_ip_block.name]
}

resource "google_compute_firewall" "allow_ingress" {
  name      = "${var.name}-allow-ssh"
  network   = var.network
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = var.ports
  }
  target_tags = ["ssh-enabled"]
}

#------------------------------
# Database compute resources...
#------------------------------
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance

resource "google_sql_database_instance" "instance" {
  name                = "${var.name}-${random_id.random_suffix.hex}"
  region              = var.region
  database_version    = var.dbtype
  depends_on          = [google_service_networking_connection.private_vpc_connection]
  deletion_protection = "false"

  settings {
    tier              = var.tier
    disk_type         = var.disk_type
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.name
  instance = google_sql_database_instance.instance.name
}

# Proxy access...
resource "google_service_account" "dbproxy_account" {
  account_id = "${var.name}-dbproxy-account"
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
  name         = "${var.name}-db-proxy"
  machine_type = var.machine_type
  zone         = var.zone

  desired_status = "RUNNING"

  allow_stopping_for_update = true

  tags = ["ssh-enabled"]

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = 10
      type  = "pd-standard"
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = templatefile("${path.module}/templates/run_cloud_sql_proxy.tpl", {
    "db_instance_name"    = "${var.name}-db-proxy",
    "service_account_key" = base64decode(google_service_account_key.dbkey.private_key),
  })

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    email  = google_service_account.dbproxy_account.email
    scopes = ["cloud-platform"]
  }
}
