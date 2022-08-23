output "id" {
  description = "The id of the load balancer"
  value       = module.lb.lb_id
}

output "arn" {
  description = "The ARN of the load balancer"
  value       = module.lb.lb_arn
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.lb.lb_dns_name
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.lb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.lb.http_tcp_listener_ids
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.lb.https_listener_arns
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.lb.https_listener_ids
}

output "target_group_arns" {
  description = "ARNs of the target groups."
  value       = module.lb.target_group_arns
}

output "zone_id" {
  description = "The zone id of the load balancer"
  value       = module.lb.lb_zone_id
}

output "target_group_names" { 
  description = "Target group names"
  value       = module.lb.target_group_names
}

