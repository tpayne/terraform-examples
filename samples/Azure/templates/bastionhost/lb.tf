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
  load_balancer_defaults = {
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location            = azurerm_resource_group.resourceGroup.location
    tags                = azurerm_resource_group.resourceGroup.tags
    subnet_id           = azurerm_subnet.backend_subnet.id
  }
}

module "internal-lb" {
  source   = "./modules/internal-lb"
  defaults = local.load_balancer_defaults
  name     = "${var.project}-backend-lb"

  load_balancer_rules = [{
    protocol      = "Tcp",
    frontend_port = 80,
    backend_port  = 80
    },
    {
      protocol      = "Tcp",
      frontend_port = 22,
      backend_port  = 22
    }
  ]
}




