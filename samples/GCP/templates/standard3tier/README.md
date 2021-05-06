Standard 3 Tier Example
=======================

This example uses terraform on GCP to create a standard 3 tier module.

The frontend is contained in a VPC and fronted by a global HTTP/S load balancer which distributes traffic to two regional managed instance groups.

The backend is contained in a VPC which is fronted by an internal load balancer which distributes traffic to a managed instance group (MIG).

The database is contained in a VPC which hosts a private Postgres instance and a connection proxy.

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
* You have modified the `creds` variable in the file `terraform.tfvars` file to point to the location of the JWT file

For more information on how to generate your JWT token, please see the main project page.

Usage
-----
The following instructions show how to deploy it.

    % terraform init
    % terraform plan
    % terraform apply -auto-approve

Running the Sample in Cloud Shell
---------------------------------
To run the example in Cloud Shell, press the button below.

[<img src="http://gstatic.com/cloudssh/images/open-btn.png" alt="Run on Google Cloud" height="40">][run_button_auto]

To Test
-------
To test the frontend service (which essentially is the only thing accessible), please do...

    % curl http://$(terraform output frontend-load-balancer-ip | sed 's|"||g')/index.php
    % open http://$(terraform output frontend-load-balancer-ip | sed 's|"||g')/index.php

Accessing the Database
----------------------
To access the database, you can use the proxy server which gets created.

First, generate a public/private key pair and load the public key into `gcloud`

    % ssh-keygen -t rsa -f keyfile -N asimplephrase
    % gcloud compute os-login ssh-keys add  --key-file=keyfile.pub --ttl=365d
    % gcloud compute os-login describe-profile | grep username

Next, get the various IP addresses/regions for the proxy and SQL instance, plus reset the default
Postgres password use the following...

    % gcloud compute instances list | grep dbinstance001-db-proxy
    % gcloud sql instances list | grep dbinstance001
    % gcloud sql users set-password postgres --instance=dbinstance001-60590d98 --prompt-for-password

Then, connect to the proxy server...

    % gcloud compute ssh <username>@dbinstance001-db-proxy --zone=<zone>

Once logged into the proxy server try running docker...

    % docker images
    Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.24/images/json: dial unix /var/run/docker.sock: connect: permission denied

If you get an error like the above, you may have to do the following...

    % sudo groupadd docker
    % sudo usermod -aG docker $USER
    % groups

Then log out and relogin in and try again.

    % docker images
    REPOSITORY                         TAG       IMAGE ID       CREATED       SIZE
    gcr.io/cloudsql-docker/gce-proxy   latest    4aca9841fe57   13 days ago   34.9MB
    % docker run --rm --network=host -it postgres:13-alpine psql -U postgres -h 10.87.144.3
    Password for user postgres:
    psql (13.2)
    SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
    Type "help" for help.

    postgres=> \l
                                                    List of databases
     Name         |       Owner       | Encoding |  Collate   |   Ctype    |            Access privileges
    --------------+-------------------+----------+------------+------------+-----------------------------------------
    cloudsqladmin | cloudsqladmin     | UTF8     | en_US.UTF8 | en_US.UTF8 |
    dbinstance001 | cloudsqlsuperuser | UTF8     | en_US.UTF8 | en_US.UTF8 |
    postgres      | cloudsqlsuperuser | UTF8     | en_US.UTF8 | en_US.UTF8 |
    template0     | cloudsqladmin     | UTF8     | en_US.UTF8 | en_US.UTF8 | =c/cloudsqladmin                       +
                  |                   |          |            |            | cloudsqladmin=CTc/cloudsqladmin
    template1     | cloudsqlsuperuser | UTF8     | en_US.UTF8 | en_US.UTF8 | =c/cloudsqlsuperuser                   +
                  |                   |          |            |            | cloudsqlsuperuser=CTc/cloudsqlsuperuser
    (5 rows)

    postgres=>

What is everything else then?
-----------------------------
You will find that there are also a set of other compute resources created like...
- Managed instance groups (mig) - `femig...`, `bemig...` and `dbinstance001-mig...`
- Internal load balancers
- Firewalls etc.

These are created for you to help build a 3-tier application infrastructure. The basic setup is: -
- Frontend public load balancer going to private frontend mig resources (the website from above)
- Backend private load balancer (with firewall) going to private backend mig resources (inaccessible)
- Database private load balancer (with firewall) going to private backend mig resources and database (which the public proxy can access as well as the private mig)

The MIG groups for the backend and database VPC DO NOT have internet access by default. If you want
to give them internet access, then you will need to create a router and assign it to them as shown in
the frontend MIG example.

You will need to configure this setup to meet your specific application requirements as it is simply
a SAMPLE, not a complete working system.

The following will show some of these additional services.

    % gcloud compute backend-services list
    % gcloud compute backend-services describe <projectId>-backend-lb-with-tcp-hc --region=<region>

Clean Up
--------
To clean up do...

    % terraform destroy -auto-approve

Issues
------
- This example is is only intended as a sample on how to create a system. You will need to configure it as needed

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a
result of ignoring this warning, then the fault is yours only and has nothing to do with me.

[run_button_auto]: https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/tpayne/terraform-examples&working_dir=samples/GCP/templates/standard3tier&page=shell&tutorial=README.md
