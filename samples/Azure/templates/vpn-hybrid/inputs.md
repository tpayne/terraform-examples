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
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_internal-lb"></a> [internal-lb](#module\_internal-lb) | ../modules/internal-lb | n/a |
| <a name="module_mig"></a> [mig](#module\_mig) | ../modules/mig/ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_local_network_gateway.onprem_vpn_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | resource |
| [azurerm_nat_gateway.backend_router](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_network_ddos_protection_plan.ddos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_network_security_group.bnsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.bevpngw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.resourceGroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.backend_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.begateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.bensgass001](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.bevnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_gateway.bvng001](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_gateway_connection.onprem2be](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |
| [template_file.group-startup-script](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_pwd"></a> [admin\_pwd](#input\_admin\_pwd) | n/a | `string` | `"ThisIsNotAStrongPassword-123"` | no |
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | n/a | `string` | `"azureuser"` | no |
| <a name="input_backend_cidr_range"></a> [backend\_cidr\_range](#input\_backend\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_backendsn_cidr_range"></a> [backendsn\_cidr\_range](#input\_backendsn\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_backendvpn_cidr_range"></a> [backendvpn\_cidr\_range](#input\_backendvpn\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_images"></a> [images](#input\_images) | n/a | `map(any)` | <pre>{<br>  "centos": "centos8",<br>  "coreos": "coreos",<br>  "mssql": "mssql2017exp",<br>  "ubunto16": "ubuntu1604",<br>  "ubunto18": "ubuntu1804",<br>  "win2012": "windows2012r2dc",<br>  "win2016": "windows2016dc",<br>  "win2019": "windows2019dc"<br>}</pre> | no |
| <a name="input_machine_types"></a> [machine\_types](#input\_machine\_types) | n/a | `map(any)` | <pre>{<br>  "dev": "Standard_D2_v2",<br>  "micro": "Standard_B1ls",<br>  "prod": "Standard_D8s_v3",<br>  "test": "Standard_D2as_v4"<br>}</pre> | no |
| <a name="input_onprem_cidr_range"></a> [onprem\_cidr\_range](#input\_onprem\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_onprem_gateway_ip"></a> [onprem\_gateway\_ip](#input\_onprem\_gateway\_ip) | n/a | `string` | `""` | no |
| <a name="input_peer_asn"></a> [peer\_asn](#input\_peer\_asn) | n/a | `number` | `64513` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | n/a | yes |
| <a name="input_region_be"></a> [region\_be](#input\_region\_be) | n/a | `string` | `"uksouth"` | no |
| <a name="input_size"></a> [size](#input\_size) | n/a | `number` | `3` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | `map(any)` | <pre>{<br>  "basic": "Basic",<br>  "free": "Free",<br>  "rapid": "HighPerformance",<br>  "standard": "Standard",<br>  "uksouth": "18.04-LTS",<br>  "ultra": "UltraPerformance",<br>  "westus2": "16.04-LTS"<br>}</pre> | no |
| <a name="input_sku_storage"></a> [sku\_storage](#input\_sku\_storage) | n/a | `map(any)` | <pre>{<br>  "localrs": "Standard_LRS"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "env": "development",<br>  "team": "dev"<br>}</pre> | no |
| <a name="input_vpn_gen"></a> [vpn\_gen](#input\_vpn\_gen) | n/a | `map(any)` | <pre>{<br>  "gen1": "Generation1",<br>  "gen2": "Generation2"<br>}</pre> | no |
| <a name="input_vpn_shared_key"></a> [vpn\_shared\_key](#input\_vpn\_shared\_key) | n/a | `string` | `"4-v3ry-53cr3t-k3y-t0-u53"` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | n/a | `map(any)` | <pre>{<br>  "ipsec": "IPsec",<br>  "policy": "PolicyBased",<br>  "route": "RouteBased",<br>  "vnet": "Vnet2Vnet"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend-vpn-ip"></a> [backend-vpn-ip](#output\_backend-vpn-ip) | n/a |
| <a name="output_frontend-vpn-ip"></a> [frontend-vpn-ip](#output\_frontend-vpn-ip) | n/a |
| <a name="output_loadbalancer-ip"></a> [loadbalancer-ip](#output\_loadbalancer-ip) | n/a |
