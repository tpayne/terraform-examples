output "neptune-cluster" {
  description = "The details of the cluster"
  value = {
    id   = (var.create_cluster) ? aws_neptune_cluster.this[0].arn : null
    name = (var.create_cluster) ? aws_neptune_cluster.this[0].cluster_identifier : null
  }
}

output "neptune-cluster-snapshot" {
  description = "The details of the cluster snapshot"
  value = {
    id   = (var.create_cluster_snapshot) ? aws_neptune_cluster_snapshot.this[0].id : null
    name = (var.create_cluster_snapshot) ? aws_neptune_cluster_snapshot.this[0].db_cluster_snapshot_identifier : null
  }
}

output "neptune-db-instance" {
  description = "The details of the Neptune instances."
  value = {
    ids       = { for r in aws_neptune_cluster_instance.this : r.arn => r.identifier }
    endpoints = { for r in aws_neptune_cluster_instance.this : r.arn => r.endpoint }
  }
}
