output "allowed-ips" {
  description = "Allowed IP CIDRs"
  value       = concat([local.network-firewall-config.control-cidr], [])
}
