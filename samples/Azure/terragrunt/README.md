# TerraGrunt Examples
Some simple educational terragrunt work for people to use. Examples will be added as I get around to them.

Terragrunt is a tool for managing many different types of configurations which share common definitions and variables.
You can reuse definitions using crude inheritance and then customise variables using a hierarchy of directories. It is similar
in concept to `kustomize` in `kubectl`.

For more information, refer to the references below.

Dependencies
------------
To run these samples, you will need...

* Access to an Azure environment able to run Terraform (admin access)
* Installed `Terragrunt` and `Terraform`

How to Install
--------------
Install Terragrunt using appropriate instructions for your OS [Getting started](https://terragrunt.gruntwork.io/docs/getting-started/install/)

Running the samples
-------------------
To run the samples, do the following...

	cd samples/Azure/terragrunt/
	(cd dev/k8s && terragrunt plan && terragrunt destroy -auto-approve && terragrunt apply -auto-approve && terragrunt destroy -auto-approve)
	(cd prod/k8s && terragrunt plan && terragrunt destroy -auto-approve && terragrunt apply -auto-approve && terragrunt destroy -auto-approve)
	
You can delete all the resources using `terragrunt destroy -auto-approve`

The sample works by customising the name of the resources created to reflect the environment being used - either dev or prod.

References
----------
* https://terragrunt.gruntwork.io/docs/getting-started/install/
* https://blog.boltops.com/2020/09/28/terraform-vs-terragrunt-vs-terraspace/#:~:text=For%20example%3A%20terragrunt%20apply%20%3D%3E%20terraform%20apply%20terragrunt,beneficial%20logic%20before%20and%20after%20the%20terraform%20calls.
* https://ifi.tech/2020/11/26/implementing-terragrunt-with-terraform-on-azure/
* https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example
* https://davidbegin.github.io/terragrunt/
* https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/terragrunt.hcl
* https://terragrunt.gruntwork.io/docs/getting-started/quick-start/
* https://stackoverflow.com/questions/61140984/terragrunt-and-common-variables#:~:text=You%20can%20merge%20all%20inputs%20defined%20in%20some,to%20reference%20the%20values%20of%20the%20parsed%20config.
