# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# This section will declare the providers needed...
# terraform init -upgrade

data "template_file" "group-startup-script" {
  template = file("${format("%s/startup.sh.tpl", path.module)}")
}


resource "google_compute_instance_template" "frontend_template" {
  name           = "frontend-template-001"
  machine_type   = var.machine_types.dev
  can_ip_forward = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.images.ubunto
  }

  network_interface {
    subnetwork = google_compute_subnetwork.frontend_subnet.id
  }

  metadata = {
    startup-script = data.template_file.group-startup-script.template
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "frontend_target_pool" {
  name = "frontend-target-pool"
}

resource "google_compute_autoscaler" "frontend_compute_scaler" {
  name   = "frontend-compute-scaler001"
  zone   = var.zone1
  target = google_compute_instance_group_manager.frontend_group_manager.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}


resource "google_compute_instance_group_manager" "frontend_group_manager" {
  name = "frontend-group-manager"
  zone = var.zone1

  version {
    instance_template = google_compute_instance_template.frontend_template.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.frontend_target_pool.id]
  base_instance_name = "instancename"
}

