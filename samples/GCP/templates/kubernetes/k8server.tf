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

##############################
# Create computer resources...
##############################

#------------------------------
# Backend K8s resources...
#------------------------------

# Create a backend k8s services...
# GKE cluster

resource "google_service_account" "default" {
  account_id = "${var.project}-gke-account"
}

resource "google_container_cluster" "k8s_server" {
  name     = "${var.project}-gke-001"
  location = var.region_be

  remove_default_node_pool = true
  initial_node_count       = var.gke_nodes_pool_size

  network    = google_compute_network.backend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.backend_subnet.self_link

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "memory"
      minimum       = 16
      maximum       = 24
    }
    resource_limits {
      resource_type = "cpu"
      minimum       = 2
      maximum       = 10
    }
  }

  enable_shielded_nodes       = true
  enable_binary_authorization = true

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.access_cidr_range
    }
  }

  node_version       = var.gke_version
  min_master_version = var.gke_version

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  vertical_pod_autoscaling {
    enabled = true
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  maintenance_policy {
    recurring_window {
      start_time = "2021-05-10T23:00:00Z"
      end_time   = "2021-05-11T23:30:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU"
    }
  }

  node_config {
    service_account = google_service_account.default.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["gke-node", "${var.project}-gke", "be-ingress"]
    labels = {
      env = var.project
    }

    disk_type    = "pd-balanced"
    image_type   = var.images.ubunto_container
    machine_type = var.machine_types.prod
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "k8s_server_nodes" {
  name       = "${google_container_cluster.k8s_server.name}-node-pool-001"
  location   = var.region_be
  cluster    = google_container_cluster.k8s_server.name
  node_count = var.gke_nodes_pool_size

  version = var.gke_version

  node_config {
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project
    }

    # preemptible  = true
    machine_type = var.machine_types.prod
    image_type   = var.images.ubunto_container
    tags         = ["gke-node", "${var.project}-gke", "be-ingress"]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}



