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
# This sample is using modules to create a number of managed instance groups
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
# Provider syntax: https://registry.terraform.io/providers/hashicorp/google/latest/docs

# This section will declare the providers needed...
# terraform init -upgrade

###################################
# Create managed instance groups...
###################################

#------------------------------
# Startup script resource...
#------------------------------

#------------------------------
# Managed instance group template...
#------------------------------

module "femig" {
  source                     = "github.com/tpayne/terraform-examples/samples/Azure/templates/modules/mig/"
  name                       = "${var.project}fe001"
  resource_group             = azurerm_resource_group.resourceGroup.name
  location                   = azurerm_resource_group.resourceGroup.location
  subnet_id                  = azurerm_subnet.frontend_subnet.id
  load_balancer_address_pool = module.external-lb.load_balancer_backend_address_pool.id
  size                       = var.size
  image                      = var.images.ubunto18
  custom_data                = base64encode(templatefile(format("%s/templates/startup.sh.tpl", path.module), { PROXY_PATH = "" }))
  admin_user                 = var.admin_user
  admin_pwd                  = var.admin_pwd
  tags                       = var.tags
}

