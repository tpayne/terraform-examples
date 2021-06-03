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
resource "google_compute_instance_template" "database_template" {
  machine_type   = var.machine_type
  can_ip_forward = false
  name_prefix    = "db-template-001-"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.mig_image
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  metadata = {
    startup-script = data.template_file.pg-group-startup-script.rendered
    enable-oslogin = "TRUE"
    database-type  = var.dbtype
  }

  service_account {
    email  = google_service_account.dbproxy_account.email
    scopes = ["cloud-platform"]
  }

  tags = [
    var.network_name,
    "allowdb-ingress"
  ]

}


#------------------------------
# Target pool...
#------------------------------
# https://github.com/terraform-google-modules/terraform-google-vm/tree/master/modules/mig

# Primary mig...
module "db-mig-001" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "6.2.0"
  instance_template = google_compute_instance_template.database_template.self_link
  region            = var.region
  hostname          = "${var.name}-mig"
  target_size       = var.size

  network    = var.network
  subnetwork = var.subnetwork

  named_ports = var.named_ports
}

# This module is a modified form of a published GCP GCE module for internal lb that did not work
# This local modeul fixes those issues.
module "interaldb-lb" {
  source = "./../interal-lb"

  region = var.region
  name   = "${var.name}-db-lb"
  ports  = var.ports

  network    = var.network
  subnetwork = var.subnetwork

  health_check = {
    type                = "tcp"
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    response            = null
    proxy_header        = null
    port                = 5432
    port_name           = null
    request             = null
    request_path        = null
    host                = null
  }

  source_tags = [var.network_name]
  target_tags = [var.network_name]

  backends = [
    { group = module.db-mig-001.instance_group, description = "" }
  ]
}

