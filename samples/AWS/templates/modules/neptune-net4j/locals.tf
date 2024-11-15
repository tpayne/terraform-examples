locals {
  neptune-default-port      = 8182
  neptune-engine-version    = "1.2.0.1"
  neptune-engine            = "neptune"
  neptune-db-instance-class = "db.serverless"
  neptune-family            = "neptune1.2"
  
  neptune-config-params = {
    common-cluster-params = [
      {
        key   = "neptune_enable_audit_log"
        value = "1"
      }
    ]
    common-db-params = [
      {
        key   = "neptune_query_timeout"
        value = "25"
      }
    ]
  }

  allowed-cidrs = "[${local.network-firewall-config.control-cidr},${join(", ", [for s in local.network-firewall-config.subnet-cidr : format("%q", s)])}]"

  neptune-config = {
    snapshot = {
      timeout = "20m"
    }
    // Common configuration
    common = {
      instanceClass        = local.neptune-db-instance-class
      doDeletionProtection = !(var.can_delete)
      cloudwatchExports    = ["audit", "slowquery"]
      engine               = local.neptune-engine
      engineVersion        = local.neptune-engine-version
      family               = local.neptune-family
      doDbIamAuth          = true
      doSkipFinalSnapshot  = true
      doStorageEncryption  = true
    }
    dev = {
      doAllowMajorVersionUpgrade = true
      doApplyImmediately         = true
      backupRetention            = 2
      preferredBackupWindow      = "08:00-09:00"
      minCapacity                = 2.5
      maxCapacity                = 128
      clusterParams = concat(
        local.neptune-config-params["common-cluster-params"],
        var.neptune_cluster_parameters
      )
      dbParams = concat(
        local.neptune-config-params["common-db-params"],
        var.neptune_db_parameters
      )
    }
    // Production configuration
    prod = {
      doAllowMajorVersionUpgrade = true
      doApplyImmediately         = true
      backupRetention            = 30
      preferredBackupWindow      = "08:00-09:00"
      minCapacity                = 2.5
      maxCapacity                = 128
    }
  }

  // Network firewall
  network-firewall-config = {
    control-cidr = (var.access_cidr != null && length(var.access_cidr) > 0) ? var.access_cidr : "${data.external.routerip.result["ip"]}/32"
    subnet-cidr  = []

    allow = [
      {
        protocol = "tcp"
        priority = 1000
        ports    = local.neptune-default-port
      },
      {
        protocol = "tcp"
        priority = 1001
        ports    = 443
      }
    ]
  }
}
