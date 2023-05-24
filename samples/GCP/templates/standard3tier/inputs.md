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
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 1.4.0 |
| <a name="module_cloud-nat-bck"></a> [cloud-nat-bck](#module\_cloud-nat-bck) | terraform-google-modules/cloud-nat/google | 1.4.0 |
| <a name="module_database"></a> [database](#module\_database) | ../modules/database | n/a |
| <a name="module_frontend-mig-001"></a> [frontend-mig-001](#module\_frontend-mig-001) | terraform-google-modules/vm/google//modules/mig | 6.2.0 |
| <a name="module_frontend-mig-002"></a> [frontend-mig-002](#module\_frontend-mig-002) | terraform-google-modules/vm/google//modules/mig | 6.2.0 |
| <a name="module_gce-lb-http"></a> [gce-lb-http](#module\_gce-lb-http) | GoogleCloudPlatform/lb-http/google | ~> 4.4 |
| <a name="module_interal-lb"></a> [interal-lb](#module\_interal-lb) | ../modules/internal-lb | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allowbackend_ingress](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_firewall) | resource |
| [google_compute_instance_template.backend_template](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_instance_template) | resource |
| [google_compute_instance_template.frontend_template](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_instance_template) | resource |
| [google_compute_instance_template.frontend_template_bck](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_instance_template) | resource |
| [google_compute_network.backend_vpc_network](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network) | resource |
| [google_compute_network.database_vpc_network](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network) | resource |
| [google_compute_network.frontend_vpc_network](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network) | resource |
| [google_compute_network_peering.backend_databaseend_peering](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network_peering) | resource |
| [google_compute_network_peering.backend_frontend_peering](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network_peering) | resource |
| [google_compute_network_peering.databaseend_backend_peering](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network_peering) | resource |
| [google_compute_network_peering.frontend_backend_peering](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_network_peering) | resource |
| [google_compute_router.frontend_router](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_router) | resource |
| [google_compute_router.frontend_router_bck](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_router) | resource |
| [google_compute_subnetwork.backend_subnet](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.database_subnet](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.frontend_subnet](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.frontend_subnet_bck](https://registry.terraform.io/providers/hashicorp/google/3.65.0/docs/resources/compute_subnetwork) | resource |
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
| [template_file.pg-group-startup-script](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_besubnet_ip_cidr"></a> [besubnet\_ip\_cidr](#input\_besubnet\_ip\_cidr) | n/a | `string` | `""` | no |
| <a name="input_creds"></a> [creds](#input\_creds) | n/a | `any` | n/a | yes |
| <a name="input_database_type"></a> [database\_type](#input\_database\_type) | n/a | `map(any)` | <pre>{<br>  "mssql": "SQLSERVER_2017_STANDARD",<br>  "mysql": "MYSQL_8_0",<br>  "postgres": "POSTGRES_13"<br>}</pre> | no |
| <a name="input_dbsubnet_ip_cidr"></a> [dbsubnet\_ip\_cidr](#input\_dbsubnet\_ip\_cidr) | n/a | `string` | `""` | no |
| <a name="input_fesubnet_bck_ip_cidr"></a> [fesubnet\_bck\_ip\_cidr](#input\_fesubnet\_bck\_ip\_cidr) | n/a | `string` | `""` | no |
| <a name="input_fesubnet_ip_cidr"></a> [fesubnet\_ip\_cidr](#input\_fesubnet\_ip\_cidr) | n/a | `string` | `""` | no |
| <a name="input_images"></a> [images](#input\_images) | n/a | `map(any)` | <pre>{<br>  "cos": "cos-cloud/cos-stable",<br>  "deb": "debian-cloud/debian-9",<br>  "ubunto": "ubuntu-os-cloud/ubuntu-1804-lts"<br>}</pre> | no |
| <a name="input_machine_types"></a> [machine\_types](#input\_machine\_types) | n/a | `map(any)` | <pre>{<br>  "dev": "f1-micro",<br>  "prod": "n1-standard-1",<br>  "test": "n1-highcpu-32"<br>}</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_region_bck"></a> [region\_bck](#input\_region\_bck) | n/a | `string` | `"us-west1"` | no |
| <a name="input_size"></a> [size](#input\_size) | n/a | `number` | `5` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `list` | `[]` | no |
| <a name="input_zone1"></a> [zone1](#input\_zone1) | n/a | `string` | `"us-central1-b"` | no |
| <a name="input_zone2"></a> [zone2](#input\_zone2) | n/a | `string` | `"us-central1-c"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontend-load-balancer-ip"></a> [frontend-load-balancer-ip](#output\_frontend-load-balancer-ip) | n/a |
