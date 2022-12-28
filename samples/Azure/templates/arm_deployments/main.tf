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

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  # This can be used to store state about the Terraform project in the Terraform cloud...
  #backend "remote" {
  #  organization = "<YourOrg>"
  #  workspaces {
  #    name = "Example-Workspace"
  #  }
  #}
  # 
  # Or you can use Azure to store the state in like the following...
  # - List key - az storage account keys list -g <rgName>  --account-name <accName> --query '[0].value' -o tsv)
  # - Create secret into vault or into ENV - export ARM_ACCESS_KEY=$(az storage account keys list -g <rgName> --account-name <accName> --query '[0].value' -o tsv)
  # - List into value - export ARM_ACCESS_KEY=$(az keyvault secret show --name <kName> --vault-name <vName> --query value -o tsv)
  #backend "azurerm" {
  # resource_group_name  = "<rgName>"
  # storage_account_name = "<accName>"
  # container_name       = "<containerName>"
  # key                  = "terraform.tfstate"
  #}
}

provider "azurerm" {
  features {}
}

# Create a resource group...
resource "azurerm_resource_group" "resourceGroup" {
  name     = var.name
  location = var.region_be
  tags     = var.tags
}






