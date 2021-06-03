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
# This sample is using modules to create a number of backend database resources.
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

##############################
# Create Database resources...
##############################

#------------------------------
# Database network resources...
#------------------------------

# Create a database VPC network...
resource "google_compute_network" "database_vpc_network" {
  name                    = "${var.project}-vpc-dbase-001"
  auto_create_subnetworks = false
}

# Subnet database layer
resource "google_compute_subnetwork" "database_subnet" {
  name                     = "${var.project}-subnet-dbase-001"
  region                   = var.region
  network                  = google_compute_network.database_vpc_network.name
  ip_cidr_range            = "10.6.0.0/24"
  private_ip_google_access = true
}

#------------------------------
# Database compute resources...
#------------------------------

module "database" {
  source       = "../modules/database"
  name         = "dbinstance001"
  dbtype       = var.database_type.postgres
  region       = var.region
  zone         = var.zone1
  machine_type = var.machine_types.dev
  mig_image    = var.images.ubunto
  ports        = ["22", "5432", "80"]
  named_ports = [
    {
      name = "tcp",
      port = 5432
    },
    {
      name = "ssh",
      port = 22
    },
    {
      name = "http",
      port = 80
    }
  ]

  network      = google_compute_network.database_vpc_network.self_link
  network_name = google_compute_network.database_vpc_network.name
  subnetwork   = google_compute_subnetwork.database_subnet.self_link
}


