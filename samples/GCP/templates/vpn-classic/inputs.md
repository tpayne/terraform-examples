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
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend-mig-001"></a> [backend-mig-001](#module\_backend-mig-001) | terraform-google-modules/vm/google//modules/mig | 6.2.0 |
| <a name="module_backend_vpn"></a> [backend\_vpn](#module\_backend\_vpn) | terraform-google-modules/vpn/google//modules/vpn_ha | ~> 1.3.0 |
| <a name="module_cloud-nat-be"></a> [cloud-nat-be](#module\_cloud-nat-be) | terraform-google-modules/cloud-nat/google | 1.4.0 |
| <a name="module_cloud-nat-fe"></a> [cloud-nat-fe](#module\_cloud-nat-fe) | terraform-google-modules/cloud-nat/google | 1.4.0 |
| <a name="module_frontend_vpn"></a> [frontend\_vpn](#module\_frontend\_vpn) | terraform-google-modules/vpn/google//modules/vpn_ha | ~> 1.3.0 |
| <a name="module_interal-lb"></a> [interal-lb](#module\_interal-lb) | ../modules/internal-lb | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allowbackend_ingress](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allowfrontend_ingress](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_firewall) | resource |
| [google_compute_instance.bastionhost](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_instance) | resource |
| [google_compute_instance_template.backend_template](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_instance_template) | resource |
| [google_compute_network.backend_vpc_network](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network) | resource |
| [google_compute_network.frontend_vpc_network](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network) | resource |
| [google_compute_router.backend_router](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_router) | resource |
| [google_compute_router.frontend_router](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_router) | resource |
| [google_compute_subnetwork.backend_subnet](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.frontend_subnet](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
| [google_monitoring_alert_policy.cpu_alert001](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.lb_alert001](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.lb_alert002](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.lb_alert003](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.lb_alert004](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.lb_alert005](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_custom_service.service_slo](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_custom_service) | resource |
| [google_monitoring_slo.slo_gce](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_slo) | resource |
| [google_monitoring_slo.slo_lbbackend](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_slo) | resource |
| [google_monitoring_slo.slo_lbtlbackend](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_slo) | resource |
| [google_monitoring_slo.slo_monitor](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_slo) | resource |
| [google_monitoring_slo.slo_monitor_up](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/monitoring_slo) | resource |
| [template_file.group-startup-script](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_besubnet_ip_cidr"></a> [besubnet\_ip\_cidr](#input\_besubnet\_ip\_cidr) | n/a | `string` | `""` | no |
| <a name="input_creds"></a> [creds](#input\_creds) | n/a | `any` | n/a | yes |
| <a name="input_fesubnet_ip_cidr"></a> [fesubnet\_ip\_cidr](#input\_fesubnet\_ip\_cidr) | n/a | `string` | `""` | no |
| <a name="input_images"></a> [images](#input\_images) | n/a | `map(any)` | <pre>{<br>  "cos": "cos-cloud/cos-stable",<br>  "deb": "debian-cloud/debian-9",<br>  "minimal": "cos-cloud/cos-stable",<br>  "ubunto": "ubuntu-os-cloud/ubuntu-1804-lts"<br>}</pre> | no |
| <a name="input_machine_types"></a> [machine\_types](#input\_machine\_types) | n/a | `map(any)` | <pre>{<br>  "dev": "f1-micro",<br>  "prod": "n1-standard-1",<br>  "test": "n1-highcpu-32"<br>}</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | n/a | yes |
| <a name="input_region_be"></a> [region\_be](#input\_region\_be) | n/a | `string` | `"us-central1"` | no |
| <a name="input_region_be_asn"></a> [region\_be\_asn](#input\_region\_be\_asn) | n/a | `number` | `64514` | no |
| <a name="input_region_fe"></a> [region\_fe](#input\_region\_fe) | n/a | `string` | `"us-central1"` | no |
| <a name="input_region_fe_asn"></a> [region\_fe\_asn](#input\_region\_fe\_asn) | n/a | `number` | `64513` | no |
| <a name="input_secret"></a> [secret](#input\_secret) | n/a | `string` | `""` | no |
| <a name="input_size"></a> [size](#input\_size) | n/a | `number` | `5` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `list` | `[]` | no |
| <a name="input_zone_be"></a> [zone\_be](#input\_zone\_be) | n/a | `string` | `"us-central1-b"` | no |
| <a name="input_zone_fe"></a> [zone\_fe](#input\_zone\_fe) | n/a | `string` | `"us-central1-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend-vpn-link"></a> [backend-vpn-link](#output\_backend-vpn-link) | n/a |
| <a name="output_frontend-vpn-link"></a> [frontend-vpn-link](#output\_frontend-vpn-link) | n/a |
| <a name="output_loadbalancer-ip"></a> [loadbalancer-ip](#output\_loadbalancer-ip) | n/a |
