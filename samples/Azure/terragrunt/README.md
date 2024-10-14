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
To run the simple sample(s), do the following...

	cd samples/Azure/terragrunt/single
	(cd dev/k8s && terragrunt plan && terragrunt destroy -auto-approve && terragrunt apply -auto-approve && terragrunt destroy -auto-approve)
	(cd prod/k8s && terragrunt plan && terragrunt destroy -auto-approve && terragrunt apply -auto-approve && terragrunt destroy -auto-approve)
	
You can delete all the resources using `terragrunt destroy -auto-approve`

The sample works by customising the name of the resources created to reflect the environment being used - either dev or prod.

To run the more complex sample(s), do the following...

	cd samples/Azure/terragrunt/multiple
	(cd dev && terragrunt run-all plan)
	(cd dev && echo y | terragrunt run-all apply)
	(cd dev && echo y | terragrunt run-all destroy)
	(az group delete -n dev_rg_001 -y ; az group delete -n dev_rg_002 -y)
	(cd prod && terragrunt run-all plan)
	(cd prod && echo y | terragrunt run-all apply)
	(cd prod && echo y | terragrunt run-all destroy)
	(az group delete -n prod_rg_001 -y ; az group delete -n prod_rg_002 -y)
	
If the destroy does not work - as it seems to be a little bit flakey - then do the following...

	(az group delete -n dev_rg_001 -y ; az group delete -n dev_rg_002 -y)
	(az group delete -n prod_rg_001 -y ; az group delete -n prod_rg_002 -y)

The sample works by customising the name of the resources created to reflect the environment being used - either dev or prod. It also deploys
multiple modules.

The multi-tenanted sample is a mixture of the above two and is focused around having tenanted deployments with multi-environments. To deploy this, do...

	(cd samples/Azure/terragrunt/multitenant/clienta/prod \
	&& terragrunt run-all plan \
	&& terragrunt run-all plan -target azurerm_resource_group.resourceGroup \
	&& terragrunt run-all apply)

The `-target` will show the different substitutions - tags and name.

Then to clean-up, do...

	(cd samples/Azure/terragrunt/multitenant/clienta/prod \
	&& terragrunt run-all destroy)

You can run it for different environments and clients to see what the differents are - i.e. client name, env name and deployment CIDR ranges.

Notes
-----
* Terragrunt is a solution looking for a problem to solve. It is supposed to be aimed at keeping your code DRY, but you end up copying lots of config files around instead, so review your use-cases before using it as there might be better approaches
* Terragrunt does cause some perfectly good Terraform modules to fail for some odd reasons
* Terragrunt run-all does not work very well
* If you get errors about TF or module versions, then try `terragrunt run-all init -upgrade`
* You may also need to set your `ARM_SUBSCRIPTION_ID=` in the environment on Azure

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
