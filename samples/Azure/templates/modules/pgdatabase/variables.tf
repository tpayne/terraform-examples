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
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "resource_group" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "location" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "subnet_id" {
  description = "Name of the subnetwork to create resources in."
  default     = ""
}

variable "load_balancer_address_pool" {
  description = "Name of the address pool for VMSS resources."
  default     = ""
}

variable "start_ip" {
  description = "IP range to allow to connect."
  default     = ""
}

variable "end_ip" {
  description = "IP range to allow to connect."
  default     = ""
}

variable "sku" {
  description = "The sku to use"
  default     = ""
}

variable "sku_storage" {
  type = map(any)
  default = {
    localrs = "Standard_LRS"
  }
}

variable "image" {
  description = "The image to use"
  default     = ""
}

variable "profile_image" {

  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    ubuntu1604 = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }

    ubuntu1804 = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }

    centos8 = {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7.5"
      version   = "latest"
    }

    coreos = {
      publisher = "CoreOS"
      offer     = "CoreOS"
      sku       = "Stable"
      version   = "latest"
    }

    windows2012r2dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2012-R2-Datacenter"
      version   = "latest"
    }

    windows2016dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"
    }

    windows2019dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    mssql2017exp = {
      publisher = "MicrosoftSQLServer"
      offer     = "SQL2017-WS2016"
      sku       = "Express"
      version   = "latest"
    }
  }
}

variable "machine_type" {
  description = "The type to use"
  default     = ""
}

variable "dbversion" {
  description = "The DB version to use"
  default     = ""
}

variable "dbcharset" {
  description = "The DB charset to use"
  default     = "UTF8"
}

variable "dbcollation" {
  description = "The DB collation to use"
  default     = "English_United States.1252"
}

variable "storage_endpoint" {
  description = "The log endpoint to use"
  default     = ""
}

variable "storage_accesskey" {
  description = "The log endpoint key to use"
  default     = ""
}

variable "tags" {
  type = map(any)
  default = {
  }
}

variable "admin_user" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "admin_pwd" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 2
}




