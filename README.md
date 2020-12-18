# terraform-examples
Some simple educational terraform work. This file is WIP, so will change as I build up examples.
Note: These examples only work for Mac and need Docker installed

* Install Terraform using appropriate instructions for your OS (https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started)
* Goto a temporary directory and create a project directory, e.g. (cd /tmp/ && mkdir project && cd project) 
* Clone the repo
* cd project/terraform-examples
* ./get-started.sh
* cd samples/docker
* terraform plan
* terraform apply -auto-approve

# Notes
* Only run "terraform init" after you have created the TF files (.tf) as it needs to install the needed plugins
