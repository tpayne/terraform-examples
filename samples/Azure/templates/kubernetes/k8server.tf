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
# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# This section will declare the providers needed...
# terraform init -upgrade
# DEBUG - export TF_LOG=DEBUG

##############################
# Create computer resources...
##############################

resource "azurerm_log_analytics_workspace" "be_logworkspace" {
  name                = "${var.project}-law"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "be_logsolution" {
  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.be_logworkspace.id
  workspace_name        = azurerm_log_analytics_workspace.be_logworkspace.name
  location              = azurerm_resource_group.resourceGroup.location
  resource_group_name   = azurerm_resource_group.resourceGroup.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}

resource "azurerm_monitor_diagnostic_setting" "be_diagnostics" {
  name                       = "${azurerm_kubernetes_cluster.k8s_server.name}-audit"
  target_resource_id         = azurerm_kubernetes_cluster.k8s_server.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.be_logworkspace.id

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}


#------------------------------
# Backend K8s resources...
#------------------------------

# Create a backend k8s services...

# ${random_pet.prefix.id}
resource "random_pet" "prefix" {}

resource "azurerm_kubernetes_cluster" "k8s_server" {
  name                = "${var.project}-aks-001"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  dns_prefix          = "${var.project}-k8s"

  default_node_pool {
    name                = "${var.project}dp"
    node_count          = var.aks_nodes_pool_size
    vm_size             = var.machine_types.dev
    os_disk_size_gb     = var.os_disk_size
    vnet_subnet_id      = azurerm_subnet.backend_subnet.id
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2", "3"]
    enable_auto_scaling = true
    min_count           = var.aks_nodes_pool_size
    max_count           = var.aks_nodes_pool_maxsize
  }

  # You can specify private or whitelisted, but not both
  api_server_authorized_ip_ranges = [var.access_cidr_range]
  #private_cluster_enabled = true

  kubernetes_version = var.aks_version

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  sku_tier = var.sku.free

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = true
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.be_logworkspace.id
    }
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "k8s_server_nodes" {
  name                  = "${var.project}np"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s_server.id
  vm_size               = var.machine_types.dev
  vnet_subnet_id        = azurerm_subnet.backend_subnet.id
  node_count            = var.aks_nodes_pool_size
  enable_auto_scaling   = true
  min_count             = var.aks_nodes_pool_size
  max_count             = var.aks_nodes_pool_maxsize
  orchestrator_version  = var.aks_version
  priority              = "Regular"
  os_type               = "Linux"
  availability_zones    = ["1", "2", "3"]
}


