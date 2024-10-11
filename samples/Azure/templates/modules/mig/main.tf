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


#------------------------------
# Backend resources...
#------------------------------

resource "azurerm_storage_account" "migstore" {
  name                     = "${var.name}migstor"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.stacc_replication_type
}

# Primary mig...
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "${var.name}-vmss001"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.tier
  upgrade_mode        = "Automatic"

  automatic_os_upgrade_policy {
    disable_automatic_rollback  = false
    enable_automatic_os_upgrade = true
  }

  dynamic "source_image_reference" {
    for_each = [1]
    content {
      publisher = var.profile_image[lower(var.image)]["publisher"]
      offer     = var.profile_image[lower(var.image)]["offer"]
      sku       = var.profile_image[lower(var.image)]["sku"]
      version   = var.profile_image[lower(var.image)]["version"]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.sku_storage.localrs
  }

  data_disk {
    lun                  = 0
    caching              = "ReadWrite"
    create_option        = "Empty"
    disk_size_gb         = 10
    storage_account_type = var.sku_storage.localrs
  }

  admin_username                  = var.admin_user
  admin_password                  = var.admin_pwd
  disable_password_authentication = false

  custom_data = var.custom_data


  identity {
    type = "SystemAssigned"
  }

  extension {
    name                 = "MSILinuxExtension"
    publisher            = "Microsoft.ManagedIdentity"
    type                 = "ManagedIdentityExtensionForLinux"
    type_handler_version = "1.0"
    settings             = "{\"port\": 50342}"
  }

  network_interface {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.load_balancer_address_pool]
      primary                                = true
    }
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.migstore.primary_blob_endpoint
  }

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "monitor" {
  name                = "${var.name}-autoscale-config"
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  depends_on          = [azurerm_linux_virtual_machine_scale_set.vmss]
  resource_group_name = var.resource_group
  location            = var.location

  profile {
    name = "AutoScale"

    capacity {
      default = var.size
      minimum = var.size
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
