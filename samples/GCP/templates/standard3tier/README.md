Standard 3 Tier Example
=======================

This example uses terraform on GCP to create a standard 3 tier modle.

The frontend is contained in a VPC and fronted by a global HTTP/S load balancer which distributes traffic to two regional managed instance groups.

The backend is contained in a VPC which is fronted by an internal load balancer which distributes traffic to a managed instance group.

The database is contained in a VPC which hosts a private Postgres instance and a connection proxy.

Status
------
````
Work in Progress
````
Usage
-----
The following instructions show how to deploy it.

    % cd standard3tier
    % terraform init
    % terraform plan
    % terraform apply -auto-approve

To clean up do...

    % terraform destroy -auto-approve
  
Issues
------
- This example is not finished and is only intended as a sample on how to create a system. I am intending to finish it off when I get time

Liability Warning
-----------------
The contents of this repository (documents and examples) are provided “as-is” with no warrantee implied 
or otherwise about the accuracy or functionality of the examples.

You use them at your own risk. If anything results to your machine or environment or anything else as a 
result of ignoring this warning, then the fault is yours only and has nothing to do with me.
