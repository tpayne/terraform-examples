Bastion Host Example
====================

This example uses terraform on GCP to create a standard bastion host sample.

The frontend is contained in a VPC and fronted by a bastion host which is open to the internet.

The backend is contained in a VPC which is fronted by an internal load balancer which distributes traffic to a managed instance group (MIG). The managed instance group has access to the internet, but not the other way around.

Status
------
````
Ready for use
````
Usage
-----
The following instructions show how to deploy it.

    (cd bastionhost && \
     terraform init && \
     terraform plan && \
     terraform apply -auto-approve)

Running the Sample in Cloud Shell
---------------------------------
To run the example in Cloud Shell, press the button below.

[<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run on Google Cloud" height="30">][run_button_auto]

To Test
-------
To test the frontend service (which essentially is the only thing accessible), please run the following commands
at the shell prompt...

First, generate a public/private key pair and load the public key into `gcloud`.
If you have already done this from other setups, then you can skip it.

    (ssh-keygen -t rsa -f keyfile -N asimplephrase && \
     gcloud compute os-login ssh-keys add  --key-file=keyfile.pub --ttl=365d && \
     gcloud compute os-login describe-profile | grep username)

Next, get the various IP addresses for the bastion host and load balancer...

    (gcloud compute instances list | grep bastionhost && \
     echo $(terraform output bastionhost-ip | sed 's|"||g') && \
     gcloud compute forwarding-rules list | grep backend-lb && \
     echo $(terraform output loadbalancer-ip | sed 's|"||g'))

Then, connect to the bastion host (obtained from above)...

    gcloud compute ssh <username>@<projectId>-bastionhost --zone=<zone>

Once logged in then do a curl command against the load balancer IP (obtained above).
Note, you may need to wait 5 mins or so after running `terraform` for the MIG systems to get running.

    curl <loadbalancerIP>:80/index.php

This will then return customised HTML.

Clean Up
--------
To clean up do...

    terraform destroy -auto-approve

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/bastionhost&page=shell&tutorial=README.md
