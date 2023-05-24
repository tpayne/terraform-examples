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

# Peering rules - these are enough for basic peering.
resource "azurerm_virtual_network_peering" "frontend_backend_peering" {
  name                         = "${var.project}-frontendpeering-001"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  virtual_network_name         = azurerm_virtual_network.fevnet.name
  remote_virtual_network_id    = azurerm_virtual_network.bevnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "backend_frontend_peering" {
  name                         = "${var.project}-backendpeering-001"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  virtual_network_name         = azurerm_virtual_network.bevnet.name
  remote_virtual_network_id    = azurerm_virtual_network.fevnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# Gateway IPs
resource "azurerm_public_ip" "fevpngw" {
  name                = "${var.project}-fevpngw-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  tags                = var.tags
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "bevpngw" {
  name                = "${var.project}-bevpngw-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  tags                = var.tags
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "fvng001" {
  name                = "${var.project}-fvng-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  tags                = var.tags

  type       = "Vpn"
  vpn_type   = var.vpn_type.route
  enable_bgp = false
  sku        = var.sku.basic
  generation = var.vpn_gen.gen1

  ip_configuration {
    name                          = "fvpngConfig001"
    public_ip_address_id          = azurerm_public_ip.fevpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.fegateway_subnet.id
  }
}

resource "azurerm_virtual_network_gateway" "bvng001" {
  name                = "${var.project}-bvng-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  tags                = var.tags

  type       = "Vpn"
  vpn_type   = var.vpn_type.route
  enable_bgp = false
  sku        = var.sku.basic
  generation = var.vpn_gen.gen1

  ip_configuration {
    name                          = "bvpngConfig001"
    public_ip_address_id          = azurerm_public_ip.bevpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.begateway_subnet.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "fe2be" {
  name                = "${var.project}-fe2be"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location

  type                            = var.vpn_type.vnet
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.fvng001.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.bvng001.id

  shared_key = var.vpn_shared_key
}

resource "azurerm_virtual_network_gateway_connection" "be2fe" {
  name                = "${var.project}-be2fe"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location

  type                            = var.vpn_type.vnet
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.bvng001.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.fvng001.id

  shared_key = var.vpn_shared_key
}


