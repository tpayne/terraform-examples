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

variable "tier" {
  type    = string # Type - not needed, but showing it...
  default = "Standard_F2"
}

variable "sku_storage" {
  type = map(any)
  default = {
    localrs = "Standard_LRS"
  }
}

variable "size" {
  type    = number # Type - not needed, but showing it...
  default = 2
}

variable "stacc_replication_type" {
  type    = string # Type - not needed, but showing it...
  default = "LRS"
}

variable "image" {
  type    = string # Type - not needed, but showing it...
  default = ""
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

variable "custom_data" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "subnet_id" {
  type    = string # Type - not needed, but showing it...
  default = ""
}

variable "load_balancer_address_pool" {
  type    = string # Type - not needed, but showing it...
  default = ""
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



