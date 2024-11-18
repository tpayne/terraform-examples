Neptune DB Example
==================

This example uses terraform on AWS to create a standard Neptune DB sample.

Status
------
````
Ready for use
````

Generate docs
-------------
You can generate the terraform docs via...

```bash
  terraform-docs markdown . --output-mode inject --output-file README.md
```

Prerequisites
-------------
To run this tutorial, you must have ensured the following...

* You have access to a AWS account as an admin or owner

This was tested using Terraform version v1.9.5

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.37.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_neptune_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster) | resource |
| [aws_neptune_cluster_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_endpoint) | resource |
| [aws_neptune_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_instance) | resource |
| [aws_neptune_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_parameter_group) | resource |
| [aws_neptune_cluster_snapshot.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_snapshot) | resource |
| [aws_neptune_event_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_event_subscription) | resource |
| [aws_neptune_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_parameter_group) | resource |
| [aws_neptune_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_subnet_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.routerip](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidr"></a> [access\_cidr](#input\_access\_cidr) | (Optional) The accessible CIDR to use | `list(string)` | `[]` | no |
| <a name="input_can_delete"></a> [can\_delete](#input\_can\_delete) | Whether or not the cluster is delete protected | `bool` | `true` | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Cluster configuration information | <pre>object({<br>    az_list        = optional(list(string), []),<br>    cluster_name   = optional(string, null),<br>    cluster_arn    = optional(string, null),<br>    iam_roles_arns = optional(list(string), null),<br>    kms_key_arn    = optional(string, null),<br>  })</pre> | n/a | yes |
| <a name="input_cluster_endpoints"></a> [cluster\_endpoints](#input\_cluster\_endpoints) | (Optional) A map of cluster endpoints to create. | <pre>map(object({<br>    endpoint_type    = string<br>    static_members   = list(string)<br>    excluded_members = list(string)<br>    tags             = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Create a Neptune cluster | `bool` | `true` | no |
| <a name="input_create_cluster_snapshot"></a> [create\_cluster\_snapshot](#input\_create\_cluster\_snapshot) | Create a Neptune cluster snapshot | `bool` | `true` | no |
| <a name="input_create_groups"></a> [create\_groups](#input\_create\_groups) | Create cluster, db and subnet groups | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Create IAM roles etc. | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create security group on VPC | `bool` | `true` | no |
| <a name="input_db_config"></a> [db\_config](#input\_db\_config) | The db config to use | `string` | n/a | yes |
| <a name="input_enable_serverless"></a> [enable\_serverless](#input\_enable\_serverless) | Whether or not to create a Serverless Neptune cluster | `bool` | `true` | no |
| <a name="input_event_subscriptions"></a> [event\_subscriptions](#input\_event\_subscriptions) | Map of Neptune event subscriptions with names and SNS topic ARNs | `map(string)` | `null` | no |
| <a name="input_instance_configs"></a> [instance\_configs](#input\_instance\_configs) | List of instance details | <pre>list(object({<br>    instance_name       = optional(string, null),<br>    instance_class      = optional(string, null),<br>    az_name             = optional(string, null),<br>    db_param_group_name = optional(string, null),<br>    subnet_group_name   = optional(string, null),<br>    promotion_tier      = optional(number, 0)<br>  }))</pre> | `[]` | no |
| <a name="input_neptune_cluster_parameters"></a> [neptune\_cluster\_parameters](#input\_neptune\_cluster\_parameters) | (Optional) A list of Neptune cluster parameter settings | <pre>list(object({<br>    key   = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_neptune_db_parameters"></a> [neptune\_db\_parameters](#input\_neptune\_db\_parameters) | (Optional) A list of Neptune DB parameter settings | <pre>list(object({<br>    key   = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to use | `string` | `"eu-west-2"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name for the Neptune IAM role | `string` | `"iam-role-neptune"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Optional) A list of subnet IDs to associate with the Neptune cluster | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Resource tags to use | `map` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional) The VPC ID for the Neptune cluster and security group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neptune-cluster"></a> [neptune-cluster](#output\_neptune-cluster) | The details of the cluster |
| <a name="output_neptune-cluster-snapshot"></a> [neptune-cluster-snapshot](#output\_neptune-cluster-snapshot) | The details of the cluster snapshot |
| <a name="output_neptune-db-instance"></a> [neptune-db-instance](#output\_neptune-db-instance) | The details of the Neptune instances. |
| <a name="output_neptune-group-names"></a> [neptune-group-names](#output\_neptune-group-names) | The details of the group names |
<!-- END_TF_DOCS -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->