#!/bin/sh

enable()
{
echo "Enable..."
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable iam.googleapis.com sqladmin.googleapis.com
gcloud services enable storage-component.googleapis.com storage.googleapis.com
gcloud services list
}

disable()
{
echo "Disable..."
gcloud services disable compute.googleapis.com
gcloud services disable cloudresourcemanager.googleapis.com
gcloud services disable servicenetworking.googleapis.com
gcloud services disable iam.googleapis.com sqladmin.googleapis.com
gcloud services disable storage-component.googleapis.com storage.googleapis.com
gcloud services list
}

if [ "x$1" = "xenable" ]; then
        enable
else
        disable
fi
