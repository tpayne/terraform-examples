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

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region. Will default to the resource group if unspecified."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Azure tags object."
  type        = map(any)
  default     = {}
}

variable "sku" {
  description = "Azure SKU."
  type        = string
  default     = "Standard"
}

variable "subnet_id" {
  description = "Resource ID for the subnet to attach the load balancer's front-end."
  type        = string
  default     = ""
}

variable "load_balancer_rules" {
  description = "Array of load balancer rules."
  type = list(object({
    protocol      = string
    frontend_port = number
    backend_port  = number
  }))

  // Simple default added here - couldn't see this default being overridden much.
  // Set to [] if allowing load_balancer_rules_map into the default object.
  default = [{
    protocol      = "Tcp",
    frontend_port = 443,
    backend_port  = 443
    }
  ]
}

// ==============================================================================

variable "defaults" {
  description = "Optional collection of user configurable default values."
  type = object({
    resource_group_name = string
    location            = string
    tags                = map(string)
    subnet_id           = string
  })
  default = {
    resource_group_name = null
    location            = null
    tags                = {}
    subnet_id           = null
  }
}


/*
variable "defaults" {
  description = "Optional collection of user configurable default values. Matched defaults type in terraform-modules-linux-vm"
  type = object({
    resource_group_name  = string
    location             = string
    tags                 = map(string)
    vm_size              = string
    storage_account_type = string
    admin_username       = string
    admin_ssh_public_key = string
    additional_ssh_keys = list(object({
      username   = string
      public_key = string
    }))
    subnet_id            = string
    boot_diagnostics_uri = string
  })
  default = {
    resource_group_name  = null
    location             = null
    tags                 = {}
    vm_size              = null
    storage_account_type = null
    admin_username       = null
    admin_ssh_public_key = null
    additional_ssh_keys  = null
    subnet_id            = null
    boot_diagnostics_uri = null
  }
}
*/

// ==============================================================================

variable "module_depends_on" {
  type    = list(any)
  default = []
}
