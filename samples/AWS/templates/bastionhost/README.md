Bastion Host Example
====================

This example uses terraform on AWS to create a standard bastion host sample.

The frontend is contained in a VPC and fronted by a bastion host which is open to the internet.

The backend is contained in a VPC which is fronted by a VPC peer and an internal load balancer which 
distributes traffic to an autoscaling group. The group has access to the internet, but not the other 
way around.

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

    (echo $(terraform output bastionhost-ip | sed 's|"||g') && \
     echo $(terraform output loadbalancer-ip | sed 's|"||g'))

Then, connect to the bastion host (obtained from above)...

    ssh <username>@<bastionhost-ip>

Once logged in then do a curl command against the load balancer IP (obtained above).
Note, you may need to wait 5 mins or so after running `terraform` for the ASG systems to get running.

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
- Create a picture using `terraform graph | dot -Tsvg > graph.svg`

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.
