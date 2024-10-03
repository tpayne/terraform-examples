# Create a  virtual network...
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-vnet-001"
  address_space       = [var.network_cidr]
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

# Subnet network layer
resource "azurerm_subnet" "subnet" {
  name                 = "${var.project}-subnet-001"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.network_cidr]
}

# Firewall rules
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project}-nsg-001"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  dynamic "security_rule" {
    for_each = local.network-firewall-config.allow
    content {
      name                       = lookup(security_rule.value, "protocol")
      priority                   = lookup(security_rule.value, "priority")
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = lookup(security_rule.value, "protocol")
      source_port_ranges         = lookup(security_rule.value, "ports")
      destination_port_ranges    = lookup(security_rule.value, "ports")
      source_address_prefixes    = concat([local.network-firewall-config.control-cidr], [])
      destination_address_prefix = var.network_cidr
    }
  }
}
