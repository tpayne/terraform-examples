# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started

# This needs to be run first...
#az ad sp create-for-rbac --skip-assignment
#{
#   "appId": "azureadmin",
#   "displayName": "azure-cli-2019-04-11-00-46-05",
#   "name": "http://azure-cli-2019-04-11-00-46-05",
#   "password": "ThisIsA.BigPassword-15243",
#   "tenant": "azureadmin"
#}

resource "random_pet" "prefix" {}

resource "azurerm_kubernetes_cluster" "clusterInstance" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  /*
  service_principal {
    client_id     = var.admin_username
    client_secret = var.admin_password
  }
  */

  identity {
    type = "SystemAssigned"
  }

  /*
  role_based_access_control {
    enabled = true
  }
  */

  tags = var.tags
}
