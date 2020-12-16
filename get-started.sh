#!/bin/sh

# Installing terraform on Mac...
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew upgrade hashicorp/tap/terraform
terraform -install-autocomplete

# Initialise project...
cd /tmp
rm -fr project > /dev/null 2>&1
mkdir project
cd project

terraform init

# Create your .tf files as needed

# To dry run deployments...
#terraform plan

# To apply deployments...
#terraform apply
