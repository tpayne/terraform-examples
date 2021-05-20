Standard 3 Tier Example
=======================

This example uses terraform on Azure to create a standard 3 tier module.

The frontend is contained in a Vnet and fronted by a HTTP/S load balancer which distributes traffic to a virtual scale set (VMSS).

The backend is contained in a Vnet which is fronted by an internal load balancer which distributes traffic to a virtual scale set (VMSS).

The database is contained in a VPC which hosts a private Postgres instance and a private connection endpoint.

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

Running the Sample in Azure Cloud Shell
---------------------------------------
To run the example in Cloud Shell, press the button below.

[<img src="https://azure.microsoft.com/svghandler/cloud-shell.png" alt="Run in Azure Shell" width="200" height="100">][run_button_auto]

If you use this method, you will need to manually clone this git repo as Azure does not do it for you.

    git clone https://github.com/tpayne/terraform-examples.git samples/Azure/templates/

To Test
-------
To test the frontend service (which essentially is the only thing accessible), please do...

    curl http://$(terraform output frontend-load-balancer-ip | sed 's|"||g')/index.php

Then open the page at...

    open http://$(terraform output frontend-load-balancer-ip | sed 's|"||g')/index.php

Accessing the Database
----------------------
To access the database, you can use the proxy bastion which gets created. However, this is NOT
a recommended method. The database is private and can only be connected to using a private
access endpoint from the same Vnet that the database sits on.

The proxy bastion is a public machine used to provide test access and you as such, it represents
a potential security hole. However, changing this setup is left to the user. The configuration is
setup this way currently to allow you to see how the system works.

To access the database, please do the following...

    echo $(terraform output dbserver-ip | sed 's|"||g')
    ssh azureuser@$(terraform output dbproxy-ip | sed 's|"||g')

Next, using the private IP address for the SQL instance connect to the database using `psql` (which
has already been installed for you).

    psql "host=<dbserver-ip> port=5432 dbname=postgres user=azureuser@dbinstance001 \
        password=<password> sslmode=require"

You can then use `psql` standard commands

What is everything else then?
-----------------------------
You will find that there are also a set of other compute resources created like...
- VMSS
- Internal load balancers
- Firewalls etc.

These are created for you to help build a 3-tier application infrastructure. The basic setup is: -
- Frontend public load balancer going to private frontend VMSS resources (the website from above)
- Backend private load balancer (with firewall) going to private backend VMSS resources (inaccessible)
- Database private load balancer (with firewall) going to private backend VMSS resources and database (which the public proxy can access as well as the private VMSS)

You will need to configure this setup to meet your specific application requirements as it is simply
a SAMPLE, not a complete working system.

The following will show some of these additional services.

    ((az vmss list -g rg_001 --query [].name && az network lb list -g rg_001 --query [].name) &&
     (az network vnet list -g rg_001 --query [].name && az network nsg list -g rg_001 --query [].name))

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

Or, you can remove the resource group directly

    az group delete --resource-group rg_001 -y

Notes
-----
- https://github.com/terraform-azurerm-modules/terraform-azurerm-linux-vmss
- https://github.com/terraform-azurerm-modules/terraform-azurerm-load-balancer
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set#os_profile
- https://github.com/Azure/terraform-azurerm-postgresql
- https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-private-link

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://shell.azure.com/
