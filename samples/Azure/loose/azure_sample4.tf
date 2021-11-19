# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started

# Creating multiple rgs using for_each...

resource "azurerm_resource_group" "rgsmap" {

  // Create multiple groups from a map...
  for_each = {
    group_001 = "eastus"
    group_002 = "westus2"
    group_003 = "eastus"
    group_004 = "eastus"
    group_005 = "eastus"
  }

  name     = each.key
  location = each.value
}

resource "azurerm_resource_group" "rgsset" {

  // Create multiple groups from a set...
  for_each = toset(["eastus", "westus2", "eastus2", "uksouth"])

  name     = "rgset-${each.key}"
  location = each.key
}
