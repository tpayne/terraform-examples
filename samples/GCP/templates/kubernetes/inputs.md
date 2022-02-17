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
| <a name="requirement_google"></a> [google](#requirement\_google) | 3.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-nat-be"></a> [cloud-nat-be](#module\_cloud-nat-be) | terraform-google-modules/cloud-nat/google | 1.4.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allowbackend_ingress](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_firewall) | resource |
| [google_compute_network.backend_vpc_network](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network) | resource |
| [google_compute_router.backend_router](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_router) | resource |
| [google_compute_subnetwork.backend_subnet](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.k8s_server](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/container_cluster) | resource |
| [google_container_node_pool.k8s_server_nodes](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/container_node_pool) | resource |
| [google_service_account.default](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidr_range"></a> [access\_cidr\_range](#input\_access\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_backend_cidr_range"></a> [backend\_cidr\_range](#input\_backend\_cidr\_range) | n/a | `string` | `""` | no |
| <a name="input_creds"></a> [creds](#input\_creds) | n/a | `any` | n/a | yes |
| <a name="input_gke_nodes_pool_size"></a> [gke\_nodes\_pool\_size](#input\_gke\_nodes\_pool\_size) | Number of GKE nodes | `number` | `1` | no |
| <a name="input_gke_version"></a> [gke\_version](#input\_gke\_version) | n/a | `string` | `"1.19.9-gke.1400"` | no |
| <a name="input_images"></a> [images](#input\_images) | n/a | `map(any)` | <pre>{<br>  "cos": "cos-cloud/cos-stable",<br>  "deb": "debian-cloud/debian-9",<br>  "minimal": "cos-cloud/cos-stable",<br>  "ubunto": "ubuntu-os-cloud/ubuntu-1804-lts",<br>  "ubunto_container": "ubuntu_containerd"<br>}</pre> | no |
| <a name="input_machine_types"></a> [machine\_types](#input\_machine\_types) | n/a | `map(any)` | <pre>{<br>  "dev": "f1-micro",<br>  "prod": "n1-standard-1",<br>  "test": "n1-highcpu-32"<br>}</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | n/a | yes |
| <a name="input_region_be"></a> [region\_be](#input\_region\_be) | n/a | `string` | `"us-central1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `list` | `[]` | no |
| <a name="input_zone_be"></a> [zone\_be](#input\_zone\_be) | n/a | `string` | `"us-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes-allowed-range"></a> [kubernetes-allowed-range](#output\_kubernetes-allowed-range) | Networks from which access to master is permitted |
| <a name="output_kubernetes-ip"></a> [kubernetes-ip](#output\_kubernetes-ip) | K8s IP address |
| <a name="output_kubernetes-mig-urls"></a> [kubernetes-mig-urls](#output\_kubernetes-mig-urls) | List of GKE generated instance groups |
