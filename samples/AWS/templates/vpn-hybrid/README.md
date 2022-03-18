Classic VPN Peering Example
===========================

This example uses terraform on AWS to create a standard VPN on-prem/cloud hybrid sample.

An on-prem VPN gateway is created to represent the on-prem system.

The backend is contained in a Vnet which is fronted by a VPN and an internal load balancer which distributes traffic to an autoscaling group. The group has access to the internet, but not the other way around.

Status
------
````
Ready for use
````

Prerequisites
-------------
To run this tutorial, you must have ensured the following...

* You have access to a AWS account as an admin or owner

This was tested using Terraform version v0.15.2 and AWS versions...

*  aws-cli/2.2.31 Python/3.8.8 Darwin/19.6.0 exe/x86_64 prompt/off

Usage
-----
The following instructions show how to deploy it.

    (terraform init && terraform plan && terraform apply -auto-approve)

To Test
-------
To test the frontend service (which essentially is the only thing accessible), please run the following commands
at the shell prompt...

First, get the IP address of the bastion host and the load-balancer...

    (echo $(terraform output loadbalancer-ip | sed 's|"||g'))

Then do a curl command against the load balancer IP (obtained above).

Note, you may need to wait 5 mins or so after running `terraform` for the MIG systems to get running.

    curl <loadbalancerIP>:80/index.php

This will then return customised HTML.

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

You can also use AZ directly as well...

    az group delete --resource-group rg_001 -y

Notes
-----
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway
- https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples/virtual-networks
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway
- https://www.tinfoilcipher.co.uk/2020/05/28/terraform-and-azure-automated-deployment-of-s2s-vpns/

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed
- You will also need a working on-prem VPN (with valid IPs to get this setup correctly). Currently, the on-prem VPN is faked

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://shell.azure.com/
