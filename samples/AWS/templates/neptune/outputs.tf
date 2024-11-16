output "neptune-cluster" {
  description = "The details of the cluster"
  value       = module.neptunedb.neptune-cluster
}

output "neptune-cluster-snapshot" {
  description = "The details of the cluster snapshot"
  value       = module.neptunedb.neptune-cluster-snapshot
}

output "neptune-db-instance" {
  description = "The details of the Neptune instances."
  value       = module.neptunedb.neptune-db-instance
}
