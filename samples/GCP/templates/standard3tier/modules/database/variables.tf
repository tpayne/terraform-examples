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
# Declare variables that can be used. They do not need to be populated...

variable "name" {
  type        = string
  description = "Name of the database system to setup"
  default     = "db"
}

variable "network" {
  description = "Name of the network to create resources in."
  default     = ""
}

variable "subnetwork" {
  description = "Name of the subnetwork to create resources in."
  default     = ""
}

variable "region" {
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable "zone" {
  description = "Zone for cloud resources."
  default     = "us-central1-b"
}

variable "dbtype" {
  description = "Database type"
  default     = "POSTGRES_13"
}

variable "tier" {
  description = "Database tier"
  default     = "db-f1-micro"
}

variable "ports" {
  description = "Allowed ports"
  type        = list(any)
  default     = []
}

variable "disk_type" {
  description = "Database disk type"
  default     = "PD_HDD"
}

variable "machine_type" {
  description = "Database machine type"
  default     = "n1-standard-1"
}

variable "machine_image" {
  description = "Database machine image"
  default     = "cos-cloud/cos-stable"
}
