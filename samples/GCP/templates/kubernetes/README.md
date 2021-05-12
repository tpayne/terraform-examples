Kubernetes Example
==================

This example uses terraform on GCP to create a standard Kubernetes sample.

Status
------
````
Ready for use
````

Prerequisites
-------------
To run this tutorial, you must have ensured the following...

* You have access to a GCP project as an admin or owner
* You have created a GCP service account with the required privileges
* You have downloaded the JWT key for the service account
* You have modified the `creds` variable in the file `terraform.tfvars` to point to the location of the JWT file
* You have access to an on-prem VPN and have modified the file `terraform.tfvars` to point to the IP address of on-prem system

For more information on how to generate your JWT token, please see the main project page.

This was tested using Terraform version v0.15.2 and Gcloud versions...

* Google Cloud SDK 339.0.0
* app-engine-java 1.9.88
* app-engine-python 1.9.91
* beta 2021.04.30
* bq 2.0.67
* cloud-datastore-emulator 2.1.0
* core 2021.04.30
* gsutil 4.61

Usage
-----
The following instructions show how to deploy it.

    (terraform init && terraform plan && terraform apply -auto-approve)

Running the Sample in Cloud Shell
---------------------------------
To run the example in Cloud Shell, press the button below.

[<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run on Google Cloud" height="30">][run_button_auto]

To Test
-------
To check the service exists, do...

    gcloud container clusters list
    gcloud container clusters describe <clusterName> --zone <zone>

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed

Notes
-----
- https://github.com/terraform-google-modules/terraform-google-kubernetes-engine
- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/kubernetes&page=shell&tutorial=README.md
