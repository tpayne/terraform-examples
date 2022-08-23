output "oparam1" {
  description = "Param 1"
  value       = null_resource.print-vars.triggers.param1
}

output "oparam2" {
  description = "Param 2"
  value       = null_resource.print-vars.triggers.param2
}

output "oparam3" {
  description = "Param 3"
  value       = null_resource.print-vars.triggers.param3
}
