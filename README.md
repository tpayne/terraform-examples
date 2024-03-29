# Terraform-examples
Some simple educational terraform work for people to use. Examples will be added as I get around to them.

Note: These examples only work for `Mac` and some need `Docker` installed. There are currently examples for...
* Docker
* GCP
* Azure
* AWS
* Azure ARM
* GitOps

How to Install
--------------
Install Terraform using appropriate instructions for your OS [Getting started](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started)

Build Status
------------
The build will only check for HCL syntax and other simple linting errors. It does not run the examples against any terraform emulators etc.

The build will also run a "best practices" scanner to highlight security issues/improvements. However, these are not being fixed immediately as they are a mixture of: -

* Usual false positives
* Dependent architecture configuration
* Actually cause issues in public cloud provider due to "features" or bugs

If you use a sample configuration, please review the issue list generated and resolve them as best suited to your requirements. You can get a copy of the latest report from the `Actions` tab.

[![CI](https://github.com/tpayne/terraform-examples/actions/workflows/testmakegcpsamples.yml/badge.svg)](https://github.com/tpayne/terraform-examples/actions/workflows/testmakegcpsamples.yml)

Types of Samples
----------------
There are two main types of examples provided
* Loose samples
* Templates
* Metadata samples (see loose AWS)
* Modules (see templates)

The loose samples are those that are provided in the `loose` directories and are just samples to view. No guarantee is made for them working.

The template samples are those that are provided in the `template` directories and are documented and validated. The tables below provide links to the code and the READMEs for them.

References, inspirations, similar samples, other tutorials are provided in the `notes` and `references` sections as appropriate. The source for some of these samples (which have been then modified) are also given where appropriate.

Running Loose Docker Samples
----------------------------
The first set of examples are for Docker and are based on the Terraform starting examples

  * Goto a temporary directory and create a project directory
  * Clone the repo

Then, run the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/docker/loose
	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

Running GCP Samples
-------------------
The second set of examples are for GCP and are based on the Terraform starting examples (the loose samples).

To use these samples you will have to have access to a GCP project in the cloud, then create a JSON service account file (with `Project -> Editor role`) granted. This creds file will need to be downloaded and available for use.

To run these tutorials, you must have ensured the following...

* You have access to a GCP project as an admin or owner
* You have created a GCP service account with the required privileges
* You have downloaded the JWT key for the service account
* You have modified the `creds` variable in the file `terraform.tfvars` file to point to the location of the JWT file

For more information on how to generate your JWT token, please see the main project page.

These were tested using Terraform version v0.15.2 and Gcloud versions...

* Google Cloud SDK 339.0.0
* app-engine-java 1.9.88
* app-engine-python 1.9.91
* beta 2021.04.30
* bq 2.0.67
* cloud-datastore-emulator 2.1.0
* core 2021.04.30
* gsutil 4.61

Once you have confirmed the above, then you can...

* Goto a temporary directory and create a project directory
* Clone the repo

#### Running the Loose samples
To run the loose samples, do the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/GCP/loose

You may need to enable various services as well...

	gcloud services enable compute.googleapis.com
	gcloud services enable cloudresourcemanager.googleapis.com
	gcloud services enable servicenetworking.googleapis.com
	gcloud services enable iam.googleapis.com sqladmin.googleapis.com
	gcloud services list

Edit the `terraform.tfvars` file to replace the project and creds values with those specific for you, then do...

	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

#### Running the Template samples
The following are the provided template examples.

Note: These samples assume that you have a default project and zone set in your CLI environment. You can do this with

	gcloud config set project <projectId>
	gcloud config set compute/zone <zone>

Failure to do this will lead to some of the GCP commands giving errors.

These examples also show you how to use `GCP's GCE metadata server` in web pages.

|           Sample                |        Description       |     Deploy    |
| ------------------------------- | ------------------------ | ------------- |
|[GCP/templates/bastionhost/](samples/GCP/templates/bastionhost/) | A standard bastion host example using NAT routers, internal load balancers, alerts and instance groups | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_bastionhost] |
|[GCP/templates/kubernetes/](samples/GCP/templates/kubernetes/) | A standard K8s example | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_kube] |
|[GCP/templates/standard3tier/](samples/GCP/templates/standard3tier/) | A standard 3 tier example using NAT routers, load balancers, alerts, instance groups and database | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_standardtier] |
|[GCP/templates/vpn-classic/](samples/GCP/templates/vpn-classic/) | A standard VPN peering host example using NAT routers, internal load balancers, alerts and instance groups | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_vpn] |
|[GCP/templates/vpn-hybrid/](samples/GCP/templates/vpn-hybrid/) | A standard VPN hybrid example using NAT routers, internal load balancers, alerts and instance groups | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_hybrid] |

The GCP IDE environment by default has a very old version of Terraform, so you may have to upgrade it by something like...

	wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_arm64.zip
	unzip terraform_0.15.3_linux_arm64.zip
	sudo cp terraform `which terraform`

Also remember, to get a Service account setup and modify the `terraform.tfvars` as appropriate for the correct creds file.

Failure to do so will stop the examples from working.

Running Azure Samples
---------------------
The third set of examples are for Azure and are also based on the Terraform starting examples (for the loose ones).

To use all these samples you will have to have access to an Azure project in the cloud, then use `az login` to connect to it.

To run these tutorials, you must have ensured the following...

* You have access to a Azure account as an admin or owner

These were tested using Terraform version v0.15.2 and Azure versions...

*  "azure-cli": "2.23.0",
*  "azure-cli-core": "2.23.0",
*  "azure-cli-telemetry": "1.0.6"

Once you have confirmed the above, then you can...

* Goto a temporary directory and create a project directory
* Clone the repo

#### Running the Loose samples
To run the loose samples, do the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/Azure/loose
	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

#### Running the Template samples
The following are the provided template examples.

These examples also show you how to use `Azure's IMDS` in web pages.

|           Sample                |        Description       |     Deploy    |
| ------------------------------- | ------------------------ | ------------- |
|[Azure/templates/bastionhost/](samples/Azure/templates/bastionhost/) | A standard bastion host example using NAT routers, internal load balancers and instance groups | [<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="80" height="50">][run_button_azbastion] |
|[Azure/templates/kubernetes/](samples/Azure/templates/kubernetes/) | A standard K8s example | [<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="80" height="50">][run_button_azkube] |
|[Azure/templates/standard3tier/](samples/Azure/templates/standard3tier/) | A standard 3 tier example using NAT routers, load balancers, instance groups and database | [<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="80" height="50">][run_button_azst] |
|[Azure/templates/vpn-classic/](samples/Azure/templates/vpn-classic/) | A standard VPN peering host example using NAT routers, internal load balancers and instance groups | [<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="80" height="50">][run_button_azvpnclassic] |
|[Azure/templates/vpn-hybrid/](samples/Azure/templates/vpn-hybrid/) | A standard hybrid VPN example using NAT routers, internal load balancers and instance groups | [<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="80" height="50">][run_button_azvpnclassic] |
|[Azure/templates/arm_deployments/](samples/Azure/templates/arm_deployments/) | A set of various ARM templates that demonstrate ARM functionality. They are installed using a Terraform module | [<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="80" height="50">][run_button_azarm] |
|[Azure/terragrunt/](samples/Azure/terragrunt/) | Examples using Terragrunt ||

If you use the `Deploy` button, you will need to manually clone this git repo as Azure does not do it for you.

	git clone https://github.com/tpayne/terraform-examples.git samples/Azure/templates/

Running AWS Samples
-------------------

#### Running the Loose samples
The last set of examples are for AWS and are based on the Terraform starting examples. To use them you will have to have access to an AWS project in the cloud, then use `aws configure` to connect to it. You will need to create a secure key using the IAM console under `Access keys (access key ID and secret access key)`, download the key and then input the values during the configure process.

  * Goto a temporary directory and create a project directory
  * Clone the repo

Then, run the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/AWS/loose
	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

#### Running the Template samples
These are still being created and verified. The ones present have not been verified as working as they will be changed
based on getting all the samples created.

Issues
------
- If you find any issues with these examples, then please feel free to create a PR or a branch with a pull request and I will be happy to review
- Security best practice issues are being scanned for and detected, but I am not currently fixing them. If you wish to review the issues being detected, then please review the output from the `Actions` and download the `Unit Test Results` Artifact.

Notes
-----
* Only run `terraform init` after you have created the TF files (.tf) as it needs to install the needed plugins
* Use `terraform refresh` to reapply changes and fix drift
* Use `terraform show` to show what has been deployed
* Use `terraform fmt` to change your .tf files to Terraform standard
* Use `terraform validate` to validate your configuration definition is valid
* The Terraform tutorials are located [here](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
* The Terraform tutorials on Terraform Cloud and state saving are [here](https://learn.hashicorp.com/tutorials/terraform/azure-remote?in=terraform/azure-get-started).
Essentially, it is about how to save the state files to the cloud, rather than local dirs.
* Conditional logic can be done by C style macro logic, e.g. `(test_condition) ? true : false`
* Resource block statements can be deactivated by specifying `count = 0`
* The Azure samples do not need a NAT gateway/router present. The load balancer provides SNAT translation automatically. You can remove the NAT gateway as you like, unless you want to use it for other purposes. Currently, it is redundant, but provided for potential future use for subnets not behind a LB. See [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) for more info.
* Create a picture using `terraform graph | dot -Tsvg > graph.svg`

Code Documentation
------------------
You can generate code documentation for the code by using [`terraform-doc`](https://terraform-docs.io/user-guide/installation/)

For example...

	brew install terraform-docs
	cd samples/Azure/templates
	terraform-docs markdown standard3tier

The documentation is just the default at the moment, but feel free to make more relevant contributions.

Testing Frameworks
------------------
* https://github.com/inspec/inspec-azure/tree/main/test/integration/verify/controls
* https://terratest.gruntwork.io/

Github References
-----------------
* https://github.com/marketplace/actions/publish-unit-test-results

AWS References
--------------
* https://github.com/hashicorp/terraform-provider-aws/tree/main/examples
* https://github.com/hashicorp/terraform-provider-aws/

Azure References
--------------
* https://docs.microsoft.com/en-us/azure/developer/terraform/
* https://github.com/terraform-providers/terraform-provider-azurerm
* https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes
* https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
* https://github.com/terraform-azurerm-modules#:~:text=A%20Terraform%20module%20to%20provision%20a%20container-based%20build,the%20same%20defaults%20object%20as%20the%20VM%20module.
* https://github.com/terraform-providers/terraform-provider-azurerm/tree/dc970e55b490c7b7d0522fe0e3b242b5ae00f321/examples

GCP References
--------------
* https://cloud.google.com/community/tutorials/modular-load-balancing-with-terraform
* https://codelabs.developers.google.com/codelabs/cft-onboarding#0
* https://registry.terraform.io/modules/terraform-google-modules/network/google/latest
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall#metadata
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function
* https://github.com/terraform-google-modules/terraform-google-lb-http/blob/master/examples/mig-nat-http-lb/README.md
* https://github.com/terraform-google-modules/
* https://github.com/terraform-google-modules/terraform-google-vm/tree/master/modules
* https://github.com/ryboe/private-ip-cloud-sql-db
* https://github.com/terraform-google-modules/terraform-google-lb-http/tree/master/examples/multi-mig-http-lb
* https://github.com/GoogleCloudPlatform?q=instance+group&type=&language=&sort=
* https://github.com/terraform-google-modules/terraform-google-lb-http/tree/master/examples/multi-mig-http-lb
* https://github.com/terraform-google-modules/docs-examples
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_slo
* https://cloud.google.com/blog/products/management-tools/observability-using-custom-metrics
* https://medium.com/google-cloud/stackdriver-monitoring-automation-part-3-uptime-checks-476b8507f59c
* https://medium.com/google-cloud/stackdriver-monitoring-automation-part-5-alerting-policies-ff77b19b4b97
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy
* https://github.com/EnricoMi/publish-unit-test-result-action/

[run_button_standardtier]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/standard3tier&page=shell&tutorial=README.md&cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest
[run_button_bastionhost]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/bastionhost&page=shell&tutorial=README.md&cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest
[run_button_vpn]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/vpn-classic&page=shell&tutorial=README.md&cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest
[run_button_hybrid]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/vpn-hybrid&page=shell&tutorial=README.md&cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest
[run_button_kube]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/kubernetes&page=shell&tutorial=README.md&cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:latest
[run_button_azkube]: https://shell.azure.com/
[run_button_azbastion]: https://shell.azure.com/
[run_button_azvpnclassic]: https://shell.azure.com/
[run_button_azvpnhybrid]: https://shell.azure.com/
[run_button_azst]: https://shell.azure.com/
[run_button_azarm]: https://shell.azure.com/
