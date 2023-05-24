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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.26 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.k8s_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.k8s_server_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_log_analytics_solution.be_logsolution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.be_logworkspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_nat_gateway.backend_router](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_resource_group.resourceGroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.backend_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_pet.prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidr_range"></a> [access\_cidr\_range](#input\_access\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_aks_nodes_pool_maxsize"></a> [aks\_nodes\_pool\_maxsize](#input\_aks\_nodes\_pool\_maxsize) | Number of AKS max nodes | `number` | `8` | no |
| <a name="input_aks_nodes_pool_size"></a> [aks\_nodes\_pool\_size](#input\_aks\_nodes\_pool\_size) | Number of AKS nodes | `number` | `2` | no |
| <a name="input_aks_version"></a> [aks\_version](#input\_aks\_version) | az aks get-versions -l uksouth | `string` | `"1.22.2"` | no |
| <a name="input_backend_cidr_range"></a> [backend\_cidr\_range](#input\_backend\_cidr\_range) | n/a | `string` | `"10.2.0.0/16"` | no |
| <a name="input_backendsn_cidr_range"></a> [backendsn\_cidr\_range](#input\_backendsn\_cidr\_range) | n/a | `string` | `"10.2.1.0/24"` | no |
| <a name="input_machine_types"></a> [machine\_types](#input\_machine\_types) | n/a | `map(any)` | <pre>{<br>  "dev": "Standard_D2_v2",<br>  "prod": "Standard_D8s_v3",<br>  "test": "Standard_D2as_v4"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"rg_001"` | no |
| <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size) | Standard OS disk size | `number` | `30` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"testdemo"` | no |
| <a name="input_region_be"></a> [region\_be](#input\_region\_be) | n/a | `string` | `"uksouth"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | `map(any)` | <pre>{<br>  "eastus": "18.04-LTS",<br>  "free": "Free",<br>  "westus2": "16.04-LTS"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "env": "development",<br>  "team": "dev"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes-client-cert"></a> [kubernetes-client-cert](#output\_kubernetes-client-cert) | n/a |
| <a name="output_kubernetes-client-key"></a> [kubernetes-client-key](#output\_kubernetes-client-key) | n/a |
| <a name="output_kubernetes-cluster-ca-cert"></a> [kubernetes-cluster-ca-cert](#output\_kubernetes-cluster-ca-cert) | n/a |
| <a name="output_kubernetes-config"></a> [kubernetes-config](#output\_kubernetes-config) | n/a |
| <a name="output_kubernetes-dns-service-ip"></a> [kubernetes-dns-service-ip](#output\_kubernetes-dns-service-ip) | K8s DNS service ip |
| <a name="output_kubernetes-docker-bridge-cidr"></a> [kubernetes-docker-bridge-cidr](#output\_kubernetes-docker-bridge-cidr) | K8s Docker bridge cidr |
| <a name="output_kubernetes-fqdn"></a> [kubernetes-fqdn](#output\_kubernetes-fqdn) | K8s Fully qualified domain name |
| <a name="output_kubernetes-host"></a> [kubernetes-host](#output\_kubernetes-host) | K8s hostname |
| <a name="output_kubernetes-id"></a> [kubernetes-id](#output\_kubernetes-id) | K8s Id |
| <a name="output_kubernetes-pod-cidr"></a> [kubernetes-pod-cidr](#output\_kubernetes-pod-cidr) | K8s POD cidr |
| <a name="output_kubernetes-service-cidr"></a> [kubernetes-service-cidr](#output\_kubernetes-service-cidr) | K8s Service cidr |
| <a name="output_nat-gateway-ip"></a> [nat-gateway-ip](#output\_nat-gateway-ip) | NAT gateway ip address(es) |
