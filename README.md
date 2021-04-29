# Terraform-examples
Some simple educational terraform work for people to use. Examples will be added as I get around to them.

Note: These examples only work for Mac and need Docker installed. There are currently examples for...
* Docker
* GCP
* Azure
* AWS

How to Install
--------------
Install Terraform using appropriate instructions for your OS [Getting started](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started)

Build Status
------------
[![CI](https://github.com/tpayne/terraform-examples/actions/workflows/blank.yml/badge.svg)](https://github.com/tpayne/terraform-examples/actions/workflows/blank.yml)

Running Docker Samples
----------------------
The first set of examples are for Docker and are based on the Terraform starting examples

  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project) 
  * Clone the repo

Then, run the following...

	1) cd project/terraform-examples
	2) ./get-started.sh
	3) cd samples/docker
	4) terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve -force`

Running GCP Samples
-------------------
The second set of examples are for GCP and are based on the Terraform starting examples. To use them you will have to have access to a GCP project in the cloud, then create a JSON service account file (with Project -> Editor role) granted. This creds file will need to be downloaded and available for use.


  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project) 
  * Clone the repo

Then, run the following...

	1) cd project/terraform-examples
	2) ./get-started.sh
	3) cd samples/GCP
	4) edit the "terraform.tfvars" file to replace the project and creds values with those specific for you
	5) terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve -force`

Running Azure Samples
---------------------
The third set of examples are for Azure and are based on the Terraform starting examples. To use them you will have to have access to an Azure project in the cloud, then use `az login` to connect to it.


  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project) 
  * Clone the repo

Then, run the following...

	1) cd project/terraform-examples
	2) ./get-started.sh
	3) cd samples/Azure
	4) terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve -force`

Running AWS Samples
-------------------
The last set of examples are for AWS and are based on the Terraform starting examples. To use them you will have to have access to an AWS project in the cloud, then use `aws configure` to connect to it. You will need to create a secure key using the IAM console under `Access keys (access key ID and secret access key)`, download the key and then input the values during the configure process.


  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project) 
  * Clone the repo

Then, run the following...

	1) cd project/terraform-examples
	2) ./get-started.sh
	3) cd samples/AWS
	4) terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve -force`

Notes
-----
* Only run "terraform init" after you have created the TF files (.tf) as it needs to install the needed plugins
* Use `terraform refresh` to reapply changes and fix drift
* Use `terraform show` to show what has been deployed
* To put changes into the files and apply them incrementally use (+) to add/replace DSC and (-) to remove DSC
* The Terraform tutorials are located [here](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
* The Terraform tutorials on Terraform Cloud and state saving are [here](https://learn.hashicorp.com/tutorials/terraform/azure-remote?in=terraform/azure-get-started). Essentially, it is about how to save the state files to the cloud, rather than local dirs.
* Use `terraform fmt` to change your .tf files to Terraform standard
* Use `terraform validate` to validate your configuration definition is valid
* https://docs.microsoft.com/en-us/azure/developer/terraform/
