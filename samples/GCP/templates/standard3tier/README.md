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

To Test
-------
To test the frontend service (which essentially is the only thing accessible), please do...

    % curl http://$(terraform output frontend-load-balancer-ip | sed 's|"||g')/index.php
    <!doctype html>
    <html>
    <head>
    <!-- Compiled and minified CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.0/css/materialize.min.css">
    <!-- Compiled and minified JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.0/js/materialize.min.js"></script>
    <title>Frontend Web Server</title>
    </head>
    <body>
    <div class="container">
    <div class="row">
    <div class="col s2">&nbsp;</div>
    <div class="col s8">
    <div class="card blue">
    <div class="card-content white-text">
    <div class="card-title">Backend MIG that serviced this request</div>
    </div>
    <div class="card-content white">
    <table class="bordered">
      <tbody>
        <tr>
          <td>Name</td>
    ...
    % open http://$(terraform output frontend-load-balancer-ip | sed 's|"||g')/index.php

Clean Up
--------
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
