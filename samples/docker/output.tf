# Output variables to stdout to show variables or expanded vars...

output "ip" {
  value = docker_container.ubuntu.ip_address
}

output "network_data" {
  value = docker_container.ubuntu.network_data
}
