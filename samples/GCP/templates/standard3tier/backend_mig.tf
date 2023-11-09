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
  template = file(format("%s/templates/startup-pgclient.sh.tpl", path.module))
}

#------------------------------
# Managed instance group template...
#------------------------------

# IMPORTANT - These machines DO NOT have internet access...
resource "google_compute_instance_template" "backend_template" {
  machine_type   = var.machine_types.dev
  can_ip_forward = false
  name_prefix    = "backend-template-001-"

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
    startup-script = data.template_file.pg-group-startup-script.rendered
    enable-oslogin = "TRUE"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "cloud-platform"]
  }

  tags = [
    google_compute_network.backend_vpc_network.name
  ]
}


#------------------------------
# Target pool...
#------------------------------
# https://github.com/terraform-google-modules/terraform-google-vm/tree/master/modules/mig

# Primary mig...
module "backend-mig-001" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "10.1.1"
  instance_template = google_compute_instance_template.backend_template.self_link
  region            = var.region
  hostname          = "bemig001"
  target_size       = var.size

  network    = google_compute_network.backend_vpc_network.self_link
  subnetwork = google_compute_subnetwork.backend_subnet.self_link

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

