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

resource "azurerm_local_network_gateway" "onprem_vpn_gateway" {
  name                = "${var.project}-feopgw-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  gateway_address     = var.onprem_gateway_ip
  address_space       = [var.onprem_cidr_range]

  /* If BGP needed...
  bgp_settings {
      asn = var.peer_asn
      bgp_peering_address = var.onprem_gateway_ip
  }
  */
}

# Gateway IPs
resource "azurerm_public_ip" "bevpngw" {
  name                = "${var.project}-bevpngw-001"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  tags                = var.tags
  allocation_method   = "Dynamic"
}

# Network gateway...
resource "azurerm_virtual_network_gateway" "bvng001" {
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
    name                          = "bvpngConfig001"
    public_ip_address_id          = azurerm_public_ip.bevpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.begateway_subnet.id
  }
}

# VPN connection...
resource "azurerm_virtual_network_gateway_connection" "onprem2be" {
  name                = "${var.project}-onprem2be"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location

  type                       = var.vpn_type.ipsec
  virtual_network_gateway_id = azurerm_virtual_network_gateway.bvng001.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_vpn_gateway.id

  shared_key = var.vpn_shared_key
}



