Neptune DB Example
==================

This sample uses Terraform on AWS to deploy a serverless Neptune cluster and read replica databases to different availability zones hosted in the same region. It is intended to demonstrate various capacilities of Neptune in a PoC capacity.

Status
------
````
Ready for use
````

Prerequisites
-------------
To run this sample, you must have ensured the following...

* You have access to a AWS account as an admin or owner

This was tested using Terraform version v1.9.5

Usage
-----
The following instructions show how to deploy it.

    (terraform init && terraform plan && terraform apply -auto-approve)

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

Notes
-----
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster_instance#storage_type-2
- https://docs.aws.amazon.com/neptune/latest/userguide/intro.html

Issues
------
- This example is is only intended as a sample to show how to create a system. You will need to configure and extend it as needed to better suit your requirements.

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.
