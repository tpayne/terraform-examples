data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "external" "routerip" {
  program = ["bash", "-c", "curl -s 'https://api64.ipify.org?format=json'"]
}


data "aws_iam_policy_document" "this" {
  count = (var.role_name != null) ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
