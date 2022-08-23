data "aws_subnets" "subnet_details" {
  filter {
    name   = "tag:Name"
    values = var.subnets
  }
}

data "aws_route53_zone" "zonerecord" {
  count = (var.assign_dns && var.zone_name != null && var.dns_name != null) ? 1 : 0

  name         = var.zone_name
  private_zone = var.private_zone
}
