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


locals {
  resource_group_name = coalesce(var.resource_group_name, lookup(var.defaults, "resource_group_name", "unspecified"))
  location            = coalesce(var.location, var.defaults.location)
  tags                = merge(lookup(var.defaults, "tags", {}), var.tags)
  subnet_id           = var.subnet_id != "" ? var.subnet_id : lookup(var.defaults, "subnet_id", null)

  load_balancer_rules_map = {
    for rule in var.load_balancer_rules :
    join("-", [rule.protocol, rule.frontend_port, rule.backend_port]) => {
      name          = join("-", [rule.protocol, rule.frontend_port, rule.backend_port])
      protocol      = rule.protocol
      frontend_port = rule.frontend_port
      backend_port  = rule.backend_port
    }
  }
}

# Create public IP
resource "azurerm_public_ip" "pubip" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "lbext" {
  depends_on          = [var.module_depends_on]
  name                = "${var.name}-ext"
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  sku = var.sku

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id = azurerm_lb.lbext.id
  name            = var.name
}

resource "azurerm_lb_probe" "lb" {
  for_each            = local.load_balancer_rules_map
  name                = "probe-port-${each.value.backend_port}"
  resource_group_name = local.resource_group_name
  loadbalancer_id     = azurerm_lb.lbext.id
  port                = each.value.backend_port // local.probe_port
}

resource "azurerm_lb_rule" "lb" {
  for_each                       = local.load_balancer_rules_map
  name                           = each.value.name
  resource_group_name            = local.resource_group_name
  loadbalancer_id                = azurerm_lb.lbext.id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  probe_id                       = azurerm_lb_probe.lb[each.value.name].id

  // Resource defaults as per https://www.terraform.io/docs/providers/azurerm/r/lb_rule.html
  enable_floating_ip      = false
  idle_timeout_in_minutes = 4
  load_distribution       = "Default" // All 5 tuples. Could  be set to  SourceIP or SourceIPProtocol.
  enable_tcp_reset        = false
  disable_outbound_snat   = false
}


