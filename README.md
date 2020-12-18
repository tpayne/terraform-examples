# Terraform-examples
Some simple educational terraform work. This file is WIP, so will change as I build up examples.
Note: These examples only work for Mac and need Docker installed

How to Install
--------------
Install Terraform using appropriate instructions for your OS [Getting started](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started)

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

The samples will return an error as the OS example will simply exit after creation.

As Terraform is not a "proper" CM tool, like Ansible, resources have to be deleted before they are recreated - using these samples anyway. You can change/destroy the resources by modifying the files to add (+) or remove resources (-) using the +/- syntax, but this means changing the files all the time.

You can also delete all the resources using `terraform destroy -auto-approve -force`

Running GCP Samples
-------------------
The second set of examples are for GCP and are based on the Terraform starting examples. To use them you will have to have access to a GCP project in the cloud, then create a JSON service account file (with Project -> Editor role) granted. This creds file will need to be downloaded and available for use.


  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project) 
  * Clone the repo

Then, run the following...

	1) cd project/terraform-examples
	2) ./get-started.sh
	3) cd samples/GCP
	4) edit the `terraform.tfvars` file to replace the project and creds values with those specific for you
	5) terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve -force`

Notes
-----
* Only run "terraform init" after you have created the TF files (.tf) as it needs to install the needed plugins
