# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started

# This section will declare the providers needed...
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  # This can be used to store state about the Terraform project in the Terraform cloud...
  #backend "remote" {
  #  organization = "<YourOrg>"
  #  workspaces {
  #    name = "Example-Workspace"
  #  }
  #}

}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Create a resource group...
resource "azurerm_resource_group" "resourceGroup" {
  name     = "rg_001"
  location = var.location
  tags     = var.tags
}

# Create a virtual network...
resource "azurerm_virtual_network" "vnet" {
  name                = "vpn001"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "myTFSubnet"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "PubIpAddr001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "NSG001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic01" {
  name                = "NIC001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "myNICConfg001"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_interface" "nics" {
  count               = 4
  name                = "NIC${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "myNICConfg001"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm01" {
  name                  = "LinuxVm001"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  network_interface_ids = [azurerm_network_interface.nic01.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "LinuxVm001"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_virtual_machine.vm01.resource_group_name
  depends_on          = [azurerm_virtual_machine.vm01]
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vmservers" {
  count                 = 4
  name                  = "LinuxVm001-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  network_interface_ids = [azurerm_network_interface.nics[count.index].id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "LinuxVm001-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}


