module "security_groups" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.name}-sg"
  description = "Security group for access for load balancer."
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "HTTP access from everywhere"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "HTTPS access from everywhere"
    }
  ]

  egress_rules = ["all-all"]

  tags = var.tags
}

module "lb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"

  vpc_id  = var.vpc_id
  subnets = data.aws_subnets.subnet_details.ids

  name                             = var.name
  load_balancer_type               = var.lb_type
  enable_cross_zone_load_balancing = true

  https_listeners    = var.https_listeners
  http_tcp_listeners = var.http_tcp_listeners

  security_groups = [module.security_groups.security_group_id]
  access_logs     = var.access_logs

  target_groups = var.target_groups

  tags = var.tags
}

resource "aws_route53_record" "dnsrecord" {
  count = (var.assign_dns && var.zone_name != null && var.dns_name != null) ? 1 : 0

  zone_id = data.aws_route53_zone.zonerecord[0].zone_id
  name    = "${var.dns_name}.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.lb.lb_dns_name
    zone_id                = module.lb.lb_zone_id
    evaluate_target_health = true
  }
}


