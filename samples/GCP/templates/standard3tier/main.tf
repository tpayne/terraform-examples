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
  zone        = var.zone1
}

provider "google-beta" {
  credentials = file(var.creds)
  project     = var.project
}

##############################
# Create network interfaces...
##############################

#------------------------------
# Frontend network resources...
#------------------------------
#@file:frontend_network.tf

#------------------------------
# Backend network resources...
#------------------------------
#@file:backend_network.tf

#------------------------------
# Peering network resources...
#------------------------------

# Network peering
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering

resource "google_compute_network_peering" "frontend_backend_peering" {
  name         = "${var.project}-frontendpeering-001"
  network      = google_compute_network.frontend_vpc_network.id
  peer_network = google_compute_network.backend_vpc_network.id
}

resource "google_compute_network_peering" "backend_frontend_peering" {
  name         = "${var.project}-backendpeering-001"
  network      = google_compute_network.backend_vpc_network.id
  peer_network = google_compute_network.frontend_vpc_network.id
}

resource "google_compute_network_peering" "backend_databaseend_peering" {
  name         = "${var.project}-backendpeering-002"
  network      = google_compute_network.backend_vpc_network.id
  peer_network = google_compute_network.database_vpc_network.id
}

# Network peering
resource "google_compute_network_peering" "databaseend_backend_peering" {
  name         = "${var.project}-databasepeering-001"
  network      = google_compute_network.database_vpc_network.id
  peer_network = google_compute_network.backend_vpc_network.id
}

resource "google_compute_firewall" "allowbackend_ingress" {
  name      = "${var.project}-allow-be"
  network   = google_compute_network.backend_vpc_network.self_link
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

##############################
# Create compute resources...
##############################

#------------------------------
# Frontend resources...
#------------------------------
#@file:frontend_mig.tf

#------------------------------
# Backendend resources...
#------------------------------
#@file:backend_mig.tf

#------------------------------
# Database resources...
#------------------------------
#@file:database.tf


