#!/bin/bash
set -euo pipefail
echo '${service_account_key}' >/var/svc_account_key.json
chmod 444 /var/svc_account_key.json
docker pull gcr.io/cloudsql-docker/gce-proxy:latest
docker run \
  --rm \
  -p 127.0.0.1:5432:3306 \
  -v /var/svc_account_key.json:/key.json:ro \
  gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy \
    -credential_file=/key.json
    -ip_address_types=PRIVATE
    -instances=${db_instance_name}=tcp:0.0.0.0:3306
