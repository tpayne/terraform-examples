resource "azurerm_resource_group" "resourceGroup" {
  name     = "rg${var.project}"
  location = var.region
  tags     = var.tags
}
