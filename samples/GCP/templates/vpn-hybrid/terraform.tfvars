# Replace these with your versions...
project = "testdemo-311716"
creds   = "../../terraform.json"
tags    = ["dev"]

# Replace these with your on-prem VPN...
onprem_peering_ip001 = "111.222.1.0"
onprem_peering_ip002 = "111.222.1.1"

backend_iprange001           = "169.254.0.1/30"
backend_iprange002           = "169.254.1.1/30"
backend_routerpeer_ipaddr001 = "169.254.0.2"
backend_routerpeer_ipaddr002 = "169.254.1.2"

backend_cidr_range = "10.2.0.0/24"

