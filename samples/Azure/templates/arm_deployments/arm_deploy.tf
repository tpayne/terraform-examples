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

##############################
# Create compute resources...
##############################

#------------------------------
# Deploy...
#------------------------------
#

module "arm_deployments3t" {
  source = "../modules/armdeployment"

  name           = "${var.name}-s3t001"
  resource_group = azurerm_resource_group.resourceGroup.name

  arm_params = "${path.module}/templates/standard3tier/s3t_params.json"
  arm_file   = "${path.module}/templates/standard3tier/s3t_deploy.json"

  tags = var.tags
}


module "arm_deployment001" {
  source = "../modules/armdeployment"

  name           = "${var.name}-001"
  resource_group = azurerm_resource_group.resourceGroup.name

  arm_params = "${path.module}/templates/healthcheck/arm_params001.json"
  arm_file   = "${path.module}/templates/healthcheck/arm_deploy001.json"

  tags = var.tags
}

module "arm_deploymentvmss001" {
  source = "../modules/armdeployment"

  name           = "${var.name}-vmss001"
  resource_group = azurerm_resource_group.resourceGroup.name

  arm_params = "${path.module}/templates/vmss-install/arm_params001.json"
  arm_file   = "${path.module}/templates/vmss-install/arm_deploy001.json"

  tags = var.tags
}

module "arm_deploymentk8s" {
  source = "../modules/armdeployment"

  name           = "${var.name}-k8s001"
  resource_group = azurerm_resource_group.resourceGroup.name

  arm_params = "${path.module}/templates/kubernetes/k8s_params.json"
  arm_file   = "${path.module}/templates/kubernetes/k8s_deploy.json"

  tags = var.tags
}
