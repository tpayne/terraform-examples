#!/bin/sh

enable()
{
echo "Enable..."
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable iam.googleapis.com sqladmin.googleapis.com iap.googleapis.com
gcloud services enable storage-component.googleapis.com storage.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable container.googleapis.com
gcloud services list
}

disable()
{
echo "Disable..."
gcloud services disable --force compute.googleapis.com
gcloud services disable --force cloudresourcemanager.googleapis.com
gcloud services disable --force servicenetworking.googleapis.com
gcloud services disable --force iam.googleapis.com sqladmin.googleapis.com iap.googleapis.com
gcloud services disable --force storage-component.googleapis.com storage.googleapis.com
gcloud services disable --force cloudbuild.googleapis.com
gcloud services disable --force container.googleapis.com
gcloud services list
}

if [ "x$1" = "xenable" ]; then
	enable
else
	disable
fi

