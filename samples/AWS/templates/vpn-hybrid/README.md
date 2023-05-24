Classic VPN Peering Example
===========================

This example uses terraform on AWS to create a standard VPN on-prem/cloud hybrid sample.

An on-prem VPN gateway is created to represent the on-prem system.

The backend is contained in a VPC which is fronted by a VPN and an internal load balancer which distributes traffic to an autoscaling group. The group has access to the internet, but not the other way around.

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

Notes
-----
- https://aws.amazon.com/ec2/instance-types/
- https://www.terraform.io/language/functions/templatefile?_ga=2.113429762.408791352.1647612847-797352187.1647139614
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#target_group_arns
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection#vgw_telemetry
- https://runebook.dev/en/docs/terraform/providers/aws/r/lb_target_group
- https://github.com/terraform-aws-modules/terraform-aws-vpn-gateway
- https://registry.terraform.io/modules/terraform-aws-modules/customer-gateway/aws/latest

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

