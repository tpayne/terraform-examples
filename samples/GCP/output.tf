# Output variables to stdout to show variables or expanded vars...

output "ip" {
  value = google_compute_address.static_ipaddr.address
}

output "vpcname" {
  value = google_compute_network.vpc_network.name
}

