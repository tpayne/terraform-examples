# Output variables to stdout to show variables or expanded vars...

output "public_ip_address" {
  value = data.azurerm_public_ip.ip.ip_address
}

output "vpcname" {
  value = azurerm_virtual_network.vnet.name
}

# Output ref via... terraform output -json rgmap | jq -r '.["group_001"]'
output "rgmap" {
  value = {
    for k, v in azurerm_resource_group.rgsmap : k => v.name
  }
}

# Output ref via... terraform output -json rgset | jq -r '.["uksouth"]'
output "rgset" {
  value = {
    for k, v in azurerm_resource_group.rgsset : k => v.name
  }
}