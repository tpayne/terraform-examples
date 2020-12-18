#!/bin/sh

# Installing terraform on Mac...
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew upgrade hashicorp/tap/terraform
terraform -install-autocomplete

# Initialise project...
cd samples
cd docker

terraform init

# Create your .tf files as needed

# To dry run deployments...
#terraform plan

# To apply deployments...
#terraform apply or terraform apply -auto-approve
