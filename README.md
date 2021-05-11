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
[![CI](https://github.com/tpayne/terraform-examples/actions/workflows/testmakegcpsamples.yml/badge.svg)](https://github.com/tpayne/terraform-examples/actions/workflows/testmakegcpsamples.yml)

Running Docker Samples
----------------------
The first set of examples are for Docker and are based on the Terraform starting examples

  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project)
  * Clone the repo

Then, run the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/docker
	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

Running GCP Samples
-------------------
The second set of examples are for GCP and are based on the Terraform starting examples. To use them you will have to have access to a GCP project in the cloud, then create a JSON service account file (with Project -> Editor role) granted. This creds file will need to be downloaded and available for use.

To run this tutorial, you must have ensured the following...

* You have access to a GCP project as an admin or owner
* You have created a GCP service account with the required privileges
* You have downloaded the JWT key for the service account
* You have modified the `creds` variable in the file `terraform.tfvars` file to point to the location of the JWT file

For more information on how to generate your JWT token, please see the main project page.

This was tested using Terraform version v0.15.2 and Gcloud versions...

* Google Cloud SDK 339.0.0
* app-engine-java 1.9.88
* app-engine-python 1.9.91
* beta 2021.04.30
* bq 2.0.67
* cloud-datastore-emulator 2.1.0
* core 2021.04.30
* gsutil 4.61

Once you have confirmed the above, then you can...

* Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project)
* Clone the repo

Then, run the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/GCP

Edit the `terraform.tfvars` file to replace the project and creds values with those specific for you, then do...

	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

#### The following are boiler plate templates for putting together common cloud architectures in GCP.

|           Sample                |        Description       |     Deploy    |
| ------------------------------- | ------------------------ | ------------- |
|[GCP/templates/standard3tier/](samples/GCP/templates/standard3tier/) | A standard 3 tier example using NAT routers, load balancers, instance groups and database | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_standardtier] |
|[GCP/templates/bastionhost/](samples/GCP/templates/bastionhost/) | A standard bastion host example using NAT routers, internal load balancers and instance groups | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_bastionhost] |
|[GCP/templates/vpn-classic/](samples/GCP/templates/vpn-classic/) | A standard VPN peering host example using NAT routers, internal load balancers and instance groups | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_vpn] |
|[GCP/templates/vpn-hybrid/](samples/GCP/templates/vpn-hybrid/) | A standard VPN hybrid example using NAT routers, internal load balancers and instance groups | [<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run in Google Shell" height="40">][run_button_hybrid] |

The GCP IDE environment by default has a very old version of Terraform, so you may have to upgrade it by something like...

	wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_arm64.zip
	unzip terraform_0.15.3_linux_arm64.zip
	sudo cp terraform `which terraform`
	
Also remember, to get a Service account setup and modify the `terraform.tfvars` as appropriate for the correct creds file.

Failure to do so will stop the examples from working.

Running Azure Samples
---------------------
The third set of examples are for Azure and are based on the Terraform starting examples. To use them you will have to have access to an Azure project in the cloud, then use `az login` to connect to it.


  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project)
  * Clone the repo

Then, run the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/Azure
	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

Running AWS Samples
-------------------
The last set of examples are for AWS and are based on the Terraform starting examples. To use them you will have to have access to an AWS project in the cloud, then use `aws configure` to connect to it. You will need to create a secure key using the IAM console under `Access keys (access key ID and secret access key)`, download the key and then input the values during the configure process.


  * Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project)
  * Clone the repo

Then, run the following...

	cd project/terraform-examples
	./get-started.sh
	cd samples/AWS
	terraform init && terraform plan && terraform apply -auto-approve

You can delete all the resources using `terraform destroy -auto-approve`

Issues
------
- If you find any issues with these examples, then please feel free to create a PR or a branch with a pull request and I will be happy to review

Notes
-----
* Only run "terraform init" after you have created the TF files (.tf) as it needs to install the needed plugins
* Use `terraform refresh` to reapply changes and fix drift
* Use `terraform show` to show what has been deployed
* To put changes into the files and apply them incrementally use (+) to add/replace DSC and (-) to remove DSC
* Use `terraform fmt` to change your .tf files to Terraform standard
* Use `terraform validate` to validate your configuration definition is valid
* The Terraform tutorials are located [here](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
* The Terraform tutorials on Terraform Cloud and state saving are [here](https://learn.hashicorp.com/tutorials/terraform/azure-remote?in=terraform/azure-get-started). 
Essentially, it is about how to save the state files to the cloud, rather than local dirs.

Azure References
--------------
* https://docs.microsoft.com/en-us/azure/developer/terraform/

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

[run_button_standardtier]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/standard3tier&page=shell&tutorial=README.md
[run_button_bastionhost]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/bastionhost&page=shell&tutorial=README.md
[run_button_vpn]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/vpn-classic&page=shell&tutorial=README.md
[run_button_hybrid]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/vpn-hybrid&page=shell&tutorial=README.md
