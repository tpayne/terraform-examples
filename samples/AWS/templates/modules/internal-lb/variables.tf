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

# This section will declare the providers needed...
# terraform init -upgrade
# DEBUG - export TF_LOG=DEBUG

variable "name" {
  type        = string
  description = "Name used for application security group, availability set, load balancer, etc."
}

variable "load_balancer_rules" {
  description = "Array of load balancer rules."

  type = list(object({
    port     = number
    protocol = string
  }))

  // Simple default added here - couldn't see this default being overridden much.
  // Set to [] if allowing load_balancer_rules_map into the default object.
  default = [{
    port     = 22,
    protocol = "TCP"
    }
  ]
}

variable "vpc_id" {
  description = "VPC for the LB"
  type        = string
}

variable "type" {
  description = "type of the LB"
  type        = string
  default     = "network"
}

variable "tags" {
  description = "Tags"
  default     = {}
}

variable "subnet_ip" {
  description = "Subnet IP"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Resource ID for the subnet to attach the load balancer"
  type        = string
  default     = ""
}

