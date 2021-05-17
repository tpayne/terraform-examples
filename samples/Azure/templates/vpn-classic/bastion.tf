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

##############################
# Create compute resources...
##############################

#------------------------------
# Frontend bastion host...
#------------------------------

# Create public IP
resource "azurerm_public_ip" "fepublicip001" {
  name                = "${var.project}-PubIpAddr001"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
}

# Create network interface
resource "azurerm_network_interface" "fe_nic01" {
  name                = "NIC001"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "nic001"
    subnet_id                     = azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.fepublicip001.id
  }
}

resource "azurerm_virtual_machine" "bastionhost" {
  name                  = "${var.project}-bastionhost"
  location              = azurerm_resource_group.resourceGroup.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name
  network_interface_ids = [azurerm_network_interface.fe_nic01.id]
  vm_size               = var.machine_types.micro
  tags                  = var.tags

  storage_os_disk {
    name              = "bastionhost"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.sku_storage.localrs
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, azurerm_resource_group.resourceGroup.location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "bastionhost"
    admin_username = var.admin_user
    admin_password = var.admin_pwd
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.bemigstore.primary_blob_endpoint
  }
}


