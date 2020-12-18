# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started


resource "random_string" "bucket" {
  length  = 8
  special = false
  upper   = false
}

# Create a bucket resource...
resource "google_storage_bucket" "sample_storage_bucket" {
  name     = "learn-gcp-${random_string.bucket.result}"
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Create a GCE instance using the resource...
resource "google_compute_instance" "gce_instance_1" {

  # Using the bucket...
  depends_on = [google_storage_bucket.sample_storage_bucket]

  name         = "instance-1"
  machine_type = "f1-micro"
  tags         = ["dev","project-12"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

# Create a GCE instance using Debian...
resource "google_compute_instance" "gce_instance_2" {
  name         = "instance-2"
  machine_type = "f1-micro"
  tags         = ["dev","project-12"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

# Create an IP resource...
resource "google_compute_address" "static_ipaddr" {
  name = "static-ip1"
}

# Create a GCE instance using the IP resource...
resource "google_compute_instance" "gce_instance_3" {
  name         = "instance-3"
  machine_type = "f1-micro"
  tags         = ["dev","project-12"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.static_ipaddr.address
    }
  }
}




