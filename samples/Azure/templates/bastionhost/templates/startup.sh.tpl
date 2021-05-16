#!/bin/sh
echo 'Install Packages'
apt-get update
apt-get install -y apache2 libapache2-mod-php net-tools -y
apt-get update

echo 'Update firewall'
ufw app list
ufw allow 'Apache Full'
ufw allow ssh
ufw status

echo 'Install HTML'
cat > /var/www/html/index.php << 'EOF'
<?php
function loadMetadata($url) {
    $opts = array(
        "http" => array(
            "method" => "GET",
            "header" => "Metadata:True"
        )
    );
    $context = stream_context_create($opts);
    $content = file_get_contents($url,false, $context);
    $obj = json_decode($content,true);
    return $obj;
}

function recurseFind($arr,$searchKey) {
    if ($arr != null) {
        foreach ($arr as $key => $val) {
            if ($key == $searchKey) {
                return $val;
            }
        }
        foreach ($arr as $key => $val) {
            if (is_array($val)) {
                $map = recurseFind($val,$searchKey);
                if ($map != null) {
                    return $map;
                }
            }
        }
    }
    return null;
}

function metadata_value($queryStr) {
    $url = "http://169.254.169.254/metadata/instance?api-version=2019-03-11";
    $obj = loadMetadata($url);
    $map = $obj;
    $key = $queryStr;

    // Calculate last key
    $array = preg_split("/\//", $key);
    $lastKey = "";
    foreach($array as $token) {
        $lastKey = $token;
    }

    // Get JSON key
    $array = preg_split("/\//", $key);
    foreach($array as $token) {
        $map = recurseFind($map,$token);
    }

    if (is_array($map)) {
        $map = recurseFind($map,$lastKey);
    }

    $obj = $map;
    if ($obj == null) {
      return "";
    } else {
      return sprintf("%s",$obj);
    }
}

?>
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
<div class="card-title">Backend VMSS instance that serviced this request</div>
</div>
<div class="card-content white">
<table class="bordered">
  <tbody>
    <tr>
      <td>Name</td>
      <td><?php printf(metadata_value("compute/name")) ?></td>
    </tr>
    <tr>
      <td>ID</td>
      <td><?php printf(metadata_value("compute/vmId")) ?></td>
    </tr>
    <tr>
      <td>Hostname</td>
      <td><?php printf(metadata_value("compute/osProfile/computerName")) ?></td>
    </tr>
    <tr>
      <td>Zone</td>
      <td><?php printf(metadata_value("compute/location")) ?></td>
    </tr>
    <tr>
      <td>Tags</td>
      <td><?php printf(metadata_value("compute/tags")) ?></td>
    </tr>
    <tr>
      <td>Machine Type</td>
      <td><?php printf(metadata_value("compute/vmSize")) ?></td>
    </tr>
    <tr>
      <td>Machine Image</td>
      <td><?php printf(metadata_value("compute/storageProfile/imageReference/offer")) ?></td>
    </tr>
    <tr>
      <td>Network Internal IP</td>
      <td><?php printf(metadata_value("network/interface/ipv4/ipAddress/privateIpAddress")) ?></td>
    </tr>
    <tr>
      <td>Network External IP</td>
      <td><?php printf(metadata_value("network/interface/ipv4/ipAddress/publicIpAddress")) ?></td>
    </tr>
    <tr>
      <td>Project</td>
      <td><?php printf(metadata_value("compute/resourceGroupName")) ?></td>
    </tr>
  </tbody>
</table>
</div>
</div>
<div class="card blue">
<div class="card-content white-text">
<div class="card-title">Proxy that handled this request</div>
</div>
<div class="card-content white">
<table class="bordered">
  <tbody>
    <tr>
      <td>Address</td>
      <td><?php printf($_SERVER["HTTP_HOST"]); ?></td>
    </tr>
  </tbody>
</table>
</div>
</div>
</div>
<div class="col s2">&nbsp;</div>
</div>
</div>
</html>
EOF

ifconfig

[[ -n "${PROXY_PATH}" ]] && mkdir -p /var/www/html/${PROXY_PATH} && \
    cp /var/www/html/index.php /var/www/html/${PROXY_PATH}/index.php

echo 'Install Network services'
chkconfig httpd on || systemctl enable httpd || systemctl enable apache2
service httpd restart || systemctl restart httpd || systemctl restart apache2
systemctl status apache2
chown -R www-data:www-data /var/www/html/

echo 'Curling local service to test...'
curl localhost:80
echo 'Script done'

