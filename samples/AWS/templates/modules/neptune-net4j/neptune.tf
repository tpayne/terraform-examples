//
// Cluster definition
//
resource "aws_neptune_cluster" "this" {
  count = (var.create_cluster) ? 1 : 0

  cluster_identifier = local.neptune-cluster-name

  deletion_protection                 = local.neptune-config["common"].doDeletionProtection
  enable_cloudwatch_logs_exports      = local.neptune-config["common"].cloudwatchExports
  engine                              = local.neptune-config["common"].engine
  engine_version                      = local.neptune-config["common"].engineVersion
  iam_database_authentication_enabled = local.neptune-config["common"].doDbIamAuth
  skip_final_snapshot                 = local.neptune-config["common"].doSkipFinalSnapshot
  storage_encrypted                   = local.neptune-config["common"].doStorageEncryption

  allow_major_version_upgrade  = local.neptune-config[var.db_config].doAllowMajorVersionUpgrade
  apply_immediately            = local.neptune-config[var.db_config].doApplyImmediately
  backup_retention_period      = local.neptune-config[var.db_config].backupRetention
  preferred_backup_window      = local.neptune-config[var.db_config].preferredBackupWindow
  preferred_maintenance_window = local.neptune-config[var.db_config].preferredMaintWindow

  iam_roles                            = try([aws_iam_role.this[0].arn], var.cluster_config.iam_roles)
  kms_key_arn                          = try(var.cluster_config.kms_key_arn, null)
  neptune_cluster_parameter_group_name = try(aws_neptune_cluster_parameter_group.this[0].name, null)
  neptune_subnet_group_name            = try(aws_neptune_subnet_group.this[0].name, null)
  vpc_security_group_ids               = try([aws_security_group.this[0].id], [])
  replication_source_identifier        = try(var.cluster_config.source_arn, null)

  availability_zones = try(var.cluster_config.az_list, [])

  dynamic "serverless_v2_scaling_configuration" {
    for_each = var.enable_serverless ? [1] : []
    content {
      min_capacity = local.neptune-config[var.db_config].minCapacity
      max_capacity = local.neptune-config[var.db_config].maxCapacity
    }
  }

  tags = var.tags
}

resource "aws_neptune_cluster_instance" "this" {
  for_each = { for index, x in var.instance_configs : x.instance_name => x }

  identifier         = try(each.value.instance_name, null)
  cluster_identifier = try(aws_neptune_cluster.this[0].cluster_identifier, local.neptune-cluster-name)
  instance_class     = (each.value.instance_class != null) ? each.value.instance_class : local.neptune-config["common"].instanceClass
  availability_zone  = try(each.value.az_name, null)
  promotion_tier     = try(each.value.promotion_tier, 0)

  apply_immediately            = local.neptune-config[var.db_config].doApplyImmediately
  //preferred_backup_window      = local.neptune-config[var.db_config].preferredBackupWindow
  //preferred_maintenance_window = local.neptune-config[var.db_config].preferredMaintWindow
  neptune_parameter_group_name = (var.create_groups) ? aws_neptune_parameter_group.this[0].name : each.value.db_param_group_name
  neptune_subnet_group_name    = (var.create_groups) ? aws_neptune_subnet_group.this[0].name : each.value.subnet_group_name

  tags = var.tags
}

resource "aws_neptune_cluster_snapshot" "this" {
  count = var.create_cluster_snapshot ? 1 : 0

  db_cluster_identifier          = try(aws_neptune_cluster.this[0].id, local.neptune-cluster-name)
  db_cluster_snapshot_identifier = local.neptune-cluster-name

  dynamic "timeouts" {
    for_each = local.neptune-cluster-name != null ? [1] : []
    content {
      create = local.neptune-config["snapshot"].timeout
    }
  }
}

//
// Endpoints
//
resource "aws_neptune_cluster_endpoint" "this" {
  for_each = { for idx, endpoint in var.cluster_endpoints : idx => endpoint if var.cluster_endpoints != null }

  cluster_identifier          = aws_neptune_cluster.this[0].cluster_identifier
  cluster_endpoint_identifier = each.key
  endpoint_type               = each.value.endpoint_type

  static_members   = each.value.static_members
  excluded_members = each.value.excluded_members
  tags             = each.value.tags
}

//
// Parameter groups
//
resource "aws_neptune_cluster_parameter_group" "this" {
  count = (length(local.neptune-config[var.db_config].clusterParams) > 0 && var.create_groups) ? 1 : 0

  name        = "cluster-parameter-group-${local.neptune-cluster-name}"
  description = "Neptune Cluster Parameter Group"
  family      = local.neptune-config["common"].family

  dynamic "parameter" {
    for_each = local.neptune-config[var.db_config].clusterParams
    content {
      name  = parameter.value.key
      value = parameter.value.value
    }
  }

  tags = var.tags
}

resource "aws_neptune_parameter_group" "this" {
  count = (length(local.neptune-config[var.db_config].dbParams) > 0 && var.create_groups) ? 1 : 0

  name        = "parameter-group-${local.neptune-cluster-name}"
  description = "Neptune DB Parameter Group"
  family      = local.neptune-config["common"].family

  dynamic "parameter" {
    for_each = local.neptune-config[var.db_config].dbParams
    content {
      name  = parameter.value.key
      value = parameter.value.value
    }
  }

  tags = var.tags
}

//
// Subnet groups
//
resource "aws_neptune_subnet_group" "this" {
  count = (var.subnet_ids != null && var.create_groups) ? 1 : 0

  name        = "subnet-group-${local.neptune-cluster-name}"
  description = "Neptune Subnet Group"
  subnet_ids  = var.subnet_ids

  tags = var.tags
}

//
// Event subscriptions
//
resource "aws_neptune_event_subscription" "this" {
  for_each = var.event_subscriptions != null ? var.event_subscriptions : {}

  name          = each.key
  sns_topic_arn = each.value
  source_type   = var.event_subscriptions != null ? "db-instance" : null
  source_ids    = try([for r in aws_neptune_cluster_instance.this : "${r.id}"], [])

  tags = var.tags
}

//
// Security groups
//
resource "aws_security_group" "this" {
  count = (var.create_security_group) ? 1 : 0

  name        = "neptune-sg-${local.neptune-cluster-name}"
  description = "Neptune security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.network-firewall-config.allow
    content {
      protocol    = lookup(ingress.value, "protocol")
      cidr_blocks = local.network-firewall-config.control-cidr
      from_port   = tonumber(lookup(ingress.value, "ports"))
      to_port     = tonumber(lookup(ingress.value, "ports"))
    }
  }

  dynamic "egress" {
    for_each = local.network-firewall-config.allow
    content {
      protocol    = lookup(egress.value, "protocol")
      cidr_blocks = local.network-firewall-config.control-cidr
      from_port   = tonumber(lookup(egress.value, "ports"))
      to_port     = tonumber(lookup(egress.value, "ports"))
    }
  }

  tags = var.tags
}

//
// IAM role
//
resource "aws_iam_role" "this" {
  count = (var.role_name != null && var.create_role) ? 1 : 0

  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.this[0].json
  description        = "Neptune management role"

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = (var.role_name != null && var.create_role) ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/ROSAKMSProviderPolicy"
}
