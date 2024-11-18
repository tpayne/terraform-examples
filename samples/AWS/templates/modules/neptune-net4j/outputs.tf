output "neptune-cluster" {
  description = "The details of the cluster"
  value = {
    arn  = (var.create_cluster) ? aws_neptune_cluster.this[0].arn : null
    name = (var.create_cluster) ? aws_neptune_cluster.this[0].cluster_identifier : null
    role = (var.create_cluster && var.create_role) ? aws_iam_role.this[0].arn : null
  }
}

output "neptune-group-names" {
  description = "The details of the group names"
  value = {
    cluster_param_group_name = (var.create_groups) ? aws_neptune_cluster_parameter_group.this[0].name : null
    param_group_name         = (var.create_groups) ? aws_neptune_parameter_group.this[0].name : null
    subnet_group_name        = (var.create_groups) ? aws_neptune_subnet_group.this[0].name : null
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
    ids = { for r in aws_neptune_cluster_instance.this : r.arn => r.identifier }
    details = {
      for r in aws_neptune_cluster_instance.this :
      r.arn =>
      "{ endpoint: \"${r.endpoint}\", writer: \"${r.writer}\", storage: \"${r.storage_type}\" }"
    }
  }
}
