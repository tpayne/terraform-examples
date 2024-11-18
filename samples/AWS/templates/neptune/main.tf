# Create a  virtual network...
resource "aws_vpc_ipam" "this" {
  operating_regions {
    region_name = data.aws_region.current.name
  }
}

resource "aws_vpc_ipam_pool" "this" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.this.private_default_scope_id
  locale         = data.aws_region.current.name
}

resource "aws_vpc_ipam_pool_cidr" "this" {
  ipam_pool_id = aws_vpc_ipam_pool.this.id
  cidr         = local.cidrBlock
}

resource "aws_vpc" "this" {
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.this.id
  ipv4_netmask_length = 16

  enable_dns_support   = true
  enable_dns_hostnames = true

  depends_on = [
    aws_vpc_ipam_pool_cidr.this
  ]
}

# Subnet network layer
resource "aws_subnet" "this" {
  for_each          = { for index, sn in local.subnets : sn.region => sn }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.subnetCidr
  availability_zone = each.value.region
}

resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
}

# Neptune module
module "neptunedb" {
  source = "../modules/neptune-net4j/"
  cluster_config = {
    cluster_name = "test"
    az_list      = [for r in local.subnets : "${r.region}"]
  }
  db_config = "dev"
  instance_configs = [
    {
      instance_name = "db01"
      az_name       = "${local.region}a"
    },
    {
      instance_name  = "db02"
      az_name        = "${local.region}b"
      promotion_tier = 1
    }
  ]
  can_delete = true
  region     = data.aws_region.current.name
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for r in aws_subnet.this : "${r.id}"]
}

/* Not needed
module "neptunedb2" {
  source                  = "../modules/neptune-net4j/"
  db_config               = "dev"
  create_cluster          = false
  create_cluster_snapshot = false
  create_groups           = false
  create_role             = false
  create_security_group   = false
  cluster_config = {
    cluster_arn  = module.neptunedb.neptune-cluster.arn
    cluster_name = module.neptunedb.neptune-cluster.name
  }
  instance_configs = [
    {
      instance_name       = "db03"
      promotion_tier      = 1
      db_param_group_name = module.neptunedb.neptune-group-names.param_group_name
      subnet_group_name   = module.neptunedb.neptune-group-names.subnet_group_name
    }
  ]
  can_delete = true
  region     = data.aws_region.current.name
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for r in aws_subnet.this : "${r.id}"]
}
*/