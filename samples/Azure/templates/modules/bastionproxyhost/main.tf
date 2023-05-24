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
resource "azurerm_public_ip" "proxyip" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

# Create network interface
resource "azurerm_network_interface" "proxynic01" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = var.name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.proxyip.id
  }
}

resource "azurerm_virtual_machine" "proxyvm" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.proxynic01.id]
  vm_size               = var.machine_type
  tags                  = var.tags

  storage_os_disk {
    name              = var.name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.sku_storage.localrs
  }

  dynamic "storage_image_reference" {

    for_each = [1]

    content {
      publisher = var.profile_image[lower(var.image)]["publisher"]
      offer     = var.profile_image[lower(var.image)]["offer"]
      sku       = var.profile_image[lower(var.image)]["sku"]
      version   = var.profile_image[lower(var.image)]["version"]
    }
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.admin_user
    admin_password = var.admin_pwd
    custom_data    = var.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.storage_endpoint
  }
}


