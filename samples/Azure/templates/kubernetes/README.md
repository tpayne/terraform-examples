Kubernetes Example
==================

This example uses terraform on Azure to create a standard Kubernetes sample.

Status
------
````
Ready for use
````

Prerequisites
-------------
To run this tutorial, you must have ensured the following...

* You have access to a Azure account as an admin or owner

This was tested using Terraform version v0.15.2 and Azure versions...

*  "azure-cli": "2.23.0",
*  "azure-cli-core": "2.23.0",
*  "azure-cli-telemetry": "1.0.6",

Usage
-----
The following instructions show how to deploy it.

    (terraform init && terraform plan && terraform apply -auto-approve)

Running the Sample in Azure Cloud Shell
---------------------------------------
To run the example in Cloud Shell, press the button below.

[<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="200" height="100">][run_button_auto]

If you use this method, you will need to manually clone this git repo as Azure does not do it for you.

	git clone https://github.com/tpayne/terraform-examples.git samples/Azure/templates/

To Test
-------
To check the service exists, do...

    az group list --query [].name
    az aks list -g rg_001
    az aks show -n <clusterName> -g rg_001

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed

Notes
-----
- https://github.com/terraform-providers/terraform-provider-azurerm
- https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/kubernetes
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
- https://github.com/terraform-azurerm-modules#:~:text=A%20Terraform%20module%20to%20provision%20a%20container-based%20build,the%20same%20defaults%20object%20as%20the%20VM%20module.
- https://aymen-segni.com/index.php/2019/12/24/create-a-kubernetes-cluster-with-azure-aks-using-terraform/
- https://github.com/AymenSegni/azure-aks-k8s-tf

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://shell.azure.com/
