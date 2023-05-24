# Create a resource group...
resource "azurerm_resource_group" "resourceGroup" {
  count = (var.create_group) ? 1 : 0

  name     = "${var.name}-rg"
  location = var.region_be
  tags     = var.tags
}

resource "azurerm_resource_group_template_deployment" "armDeployment" {
  depends_on = [
    azurerm_resource_group.resourceGroup
  ]

  name                = "${var.name}-deploy"
  resource_group_name = "${var.name}-rg"
  deployment_mode     = "Incremental"
  tags                = var.tags

  parameters_content = jsonencode({
    "actionGroupName" = {
      value = "${var.name}-alert"
    }
    "actionGroupShortName" = {
      value = "testalert"
    }
    "emailAddress" = {
      value = "${var.email}"
    }
    "activityLogAlertName" = {
      value = "serviceHealthAlert"
    }
  })

  template_content = file("${path.module}/${var.arm_file}")
}

