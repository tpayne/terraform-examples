# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started

# Create a GCE instance using Debian...
resource "google_compute_instance" "gce_instance_5" {
  name         = "instance-5"
  machine_type = var.machine_types.dev
  tags         = var.tags

  # Run a command on the machine and pipe the results locally...
  provisioner "local-exec" {
    command = "echo ${google_compute_instance.gce_instance_5.name}:  ${google_compute_instance.gce_instance_5.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"  
  }

  boot_disk {
    initialize_params {
      image = var.images.deb
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}



