# This sample is using modules to create a number of managed instance groups
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# This section will declare the providers needed...
# terraform init -upgrade

###################################
# Create managed instance groups...
###################################

#------------------------------
# Startup script resource...
#------------------------------

data "template_file" "group-startup-script" {
  template = file("${format("%s/templates/startup.sh.tpl", path.module)}")

  vars = {
    PROXY_PATH = ""
  }
}

#------------------------------
# Managed instance group template...
#------------------------------

resource "google_compute_instance_template" "frontend_template" {
  machine_type   = var.machine_types.dev
  can_ip_forward = false
  name_prefix    = "frontend-template-001-"

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
    startup-script = data.template_file.group-startup-script.rendered
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }

  tags = [
    google_compute_subnetwork.frontend_subnet.name,
    module.cloud-nat.router_name
  ]
}

resource "google_compute_instance_template" "frontend_template_bck" {
  machine_type   = var.machine_types.dev
  can_ip_forward = false
  name_prefix    = "frontend-template-002-"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.images.ubunto
  }

  network_interface {
    subnetwork = google_compute_subnetwork.frontend_subnet_bck.id
  }

  metadata = {
    startup-script = data.template_file.group-startup-script.rendered
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }

  tags = [
    google_compute_subnetwork.frontend_subnet_bck.name,
    module.cloud-nat-bck.router_name
  ]
}

#------------------------------
# Target pool...
#------------------------------
# https://github.com/terraform-google-modules/terraform-google-vm/tree/master/modules/mig

# Primary mig...
module "frontend-mig-001" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "6.2.0"
  instance_template = google_compute_instance_template.frontend_template.self_link
  region            = var.region
  hostname          = "femig001"
  target_size       = var.size

  network    = google_compute_network.frontend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.frontend_subnet.self_link

  named_ports = [
    {
      name = "http",
      port = 80
    },
    {
      name = "ssh",
      port = 22
    }    
  ]
}

# Secondary mig...
module "frontend-mig-002" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "6.2.0"
  instance_template = google_compute_instance_template.frontend_template_bck.self_link
  region            = var.region_bck
  hostname          = "femig002"
  target_size       = var.size

  network    = google_compute_network.frontend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.frontend_subnet_bck.self_link

  named_ports = [
    {
      name = "http",
      port = 80
    },
    {
      name = "ssh",
      port = 22
    }    
  ]
}

