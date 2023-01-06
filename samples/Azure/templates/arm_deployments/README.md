ARM Deployment Example
======================

This example uses terraform on Azure to perform a couple of deployments using ARM templaytes.

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
*  "azure-cli-telemetry": "1.0.6"

Usage
-----
The following instructions show how to deploy it.

    (terraform init && terraform plan && terraform apply -auto-approve)

You can just deploy a specific template by doing something like...

```console
    (az group delete -n testdemo -y || true) && \
        (az group delete -n NetworkWatcherRG -y || true) && \
        terraform destroy -auto-approve && \
        (terraform apply -target \
            module.arm_deployments3t.azurerm_resource_group_template_deployment.armDeployment \
            -auto-approve || true) &&  \
    (az group delete -n testdemo -y || true) && \
    (az group delete -n NetworkWatcherRG -y || true) && \
    terraform destroy -auto-approve
```

Running the Sample in Azure Cloud Shell
---------------------------------------
To run the example in Cloud Shell, press the button below.

[<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="200" height="100">][run_button_auto]

If you use this method, you will need to manually clone this git repo as Azure does not do it for you.

    git clone https://github.com/tpayne/terraform-examples.git samples/Azure/templates/

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

Notes
-----
- The terraform-tools image has a `pwsh` ARM best practices checker installed on it. For notes, see https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/test-toolkit#install-on-linux
- https://github.com/Azure/azure-quickstart-templates
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-string#substring
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-object#json
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-rest
- https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?pivots=deployment-language-arm-template
- https://learn.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/workspaces?pivots=deployment-language-arm-template
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/outputs?tabs=azure-powershell
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell
- https://resources.azure.com/providers/Microsoft.Compute/operations
- https://resources.azure.com/
- https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux#template-deployment
- https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.compute/vmss-custom-script-windows/azuredeploy.json
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed
- This example only demos how to sub-contract/modularise some of the template functionality - mostly the DB items. It does not similarly split up the frontend or backend components. This is left as an exercise for someone as and when
- Ideally, the common resources used by frontend, backend and db layer should be modularised as common templates, but this is not done for this example

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://shell.azure.com/
