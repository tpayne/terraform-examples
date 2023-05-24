output "resource_group" {
  value = azurerm_resource_group.resourceGroup[0].name
}

output "armop_output" {
  value = azurerm_resource_group_template_deployment.armDeployment.output_content
}

output "armop_id" {
  value = azurerm_resource_group_template_deployment.armDeployment.id
}