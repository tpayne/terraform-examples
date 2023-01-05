MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.37.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_arm_deployment001"></a> [arm\_deployment001](#module\_arm\_deployment001) | ../modules/armdeployment | n/a |
| <a name="module_arm_deploymentk8s"></a> [arm\_deploymentk8s](#module\_arm\_deploymentk8s) | ../modules/armdeployment | n/a |
| <a name="module_arm_deployments3t"></a> [arm\_deployments3t](#module\_arm\_deployments3t) | ../modules/armdeployment | n/a |
| <a name="module_arm_deploymentvmss001"></a> [arm\_deploymentvmss001](#module\_arm\_deploymentvmss001) | ../modules/armdeployment | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.resourceGroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `""` | no |
| <a name="input_region_be"></a> [region\_be](#input\_region\_be) | n/a | `string` | `"uksouth"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "env": "development",<br>  "team": "dev"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arm_deployment001-id"></a> [arm\_deployment001-id](#output\_arm\_deployment001-id) | n/a |
| <a name="output_arm_deployment001-output"></a> [arm\_deployment001-output](#output\_arm\_deployment001-output) | n/a |
| <a name="output_arm_deploymentk8s-id"></a> [arm\_deploymentk8s-id](#output\_arm\_deploymentk8s-id) | n/a |
| <a name="output_arm_deploymentk8s-output"></a> [arm\_deploymentk8s-output](#output\_arm\_deploymentk8s-output) | n/a |
| <a name="output_arm_deployments3t-id"></a> [arm\_deployments3t-id](#output\_arm\_deployments3t-id) | n/a |
| <a name="output_arm_deployments3t-output"></a> [arm\_deployments3t-output](#output\_arm\_deployments3t-output) | n/a |
| <a name="output_arm_deploymentvmss001-id"></a> [arm\_deploymentvmss001-id](#output\_arm\_deploymentvmss001-id) | n/a |
| <a name="output_arm_deploymentvmss001-output"></a> [arm\_deploymentvmss001-output](#output\_arm\_deploymentvmss001-output) | n/a |

<!-- BEGIN_TF_DOCS -->
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.37.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_arm_deployment001"></a> [arm\_deployment001](#module\_arm\_deployment001) | ../modules/armdeployment | n/a |
| <a name="module_arm_deploymentk8s"></a> [arm\_deploymentk8s](#module\_arm\_deploymentk8s) | ../modules/armdeployment | n/a |
| <a name="module_arm_deployments3t"></a> [arm\_deployments3t](#module\_arm\_deployments3t) | ../modules/armdeployment | n/a |
| <a name="module_arm_deploymentvmss001"></a> [arm\_deploymentvmss001](#module\_arm\_deploymentvmss001) | ../modules/armdeployment | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.resourceGroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `""` | no |
| <a name="input_region_be"></a> [region\_be](#input\_region\_be) | n/a | `string` | `"uksouth"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "env": "development",<br>  "team": "dev"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arm_deployment001-id"></a> [arm\_deployment001-id](#output\_arm\_deployment001-id) | n/a |
| <a name="output_arm_deployment001-output"></a> [arm\_deployment001-output](#output\_arm\_deployment001-output) | n/a |
| <a name="output_arm_deploymentk8s-id"></a> [arm\_deploymentk8s-id](#output\_arm\_deploymentk8s-id) | n/a |
| <a name="output_arm_deploymentk8s-output"></a> [arm\_deploymentk8s-output](#output\_arm\_deploymentk8s-output) | n/a |
| <a name="output_arm_deployments3t-id"></a> [arm\_deployments3t-id](#output\_arm\_deployments3t-id) | n/a |
| <a name="output_arm_deployments3t-output"></a> [arm\_deployments3t-output](#output\_arm\_deployments3t-output) | n/a |
| <a name="output_arm_deploymentvmss001-id"></a> [arm\_deploymentvmss001-id](#output\_arm\_deploymentvmss001-id) | n/a |
| <a name="output_arm_deploymentvmss001-output"></a> [arm\_deploymentvmss001-output](#output\_arm\_deploymentvmss001-output) | n/a |
<!-- END_TF_DOCS -->