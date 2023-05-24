#!/bin/sh

# Installing terraform on Mac...
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew upgrade hashicorp/tap/terraform
terraform -install-autocomplete
