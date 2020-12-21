# Output variables to stdout to show variables or expanded vars...

output "public_ip_address" {
  value = data.azurerm_public_ip.ip.ip_address
}

output "vpcname" {
  value = azurerm_virtual_network.vnet.name
}

