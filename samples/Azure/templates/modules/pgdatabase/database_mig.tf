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

###################################
# Create managed instance groups...
###################################

#------------------------------
# Startup script resource...
#------------------------------

data "template_file" "pg-group-startup-script" {
  template = file(format("%s/templates/startup-pgclient.sh.tpl", path.module))
}

#------------------------------
# Managed instance group template...
#------------------------------

module "dbmig" {
  source                     = "../../modules/mig/"
  name                       = var.name
  resource_group             = var.resource_group
  location                   = var.location
  machine_type               = var.machine_type
  subnet_id                  = var.subnet_id
  load_balancer_address_pool = var.load_balancer_address_pool
  size                       = var.size
  image                      = var.image
  custom_data                = data.template_file.pg-group-startup-script.rendered
  admin_user                 = var.admin_user
  admin_pwd                  = var.admin_pwd
  tags                       = var.tags
}


