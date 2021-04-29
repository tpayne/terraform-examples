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

data "template_file" "pg-group-startup-script" {
  template = file("${format("%s/templates/startup-pgclient.sh.tpl", path.module)}")
}

#------------------------------
# Managed instance group template...
#------------------------------

resource "google_compute_instance_template" "backend_template" {
  name           = "backend-template-001"
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
    subnetwork = google_compute_subnetwork.backend_subnet.id
  }

  metadata = {
    startup-script = data.template_file.pg-group-startup-script.template
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


#------------------------------
# Target pool...
#------------------------------
# https://github.com/terraform-google-modules/terraform-google-vm/tree/master/modules/mig

# Primary mig...
module "backend-mig-001" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "6.2.0"
  instance_template = google_compute_instance_template.backend_template.self_link
  region            = var.region
  hostname          = "bemig001"
  target_size       = var.size

  network    = google_compute_network.backend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.backend_subnet.self_link

  named_ports = [{
    name = "tcp",
    port = 5432
  }]
}


