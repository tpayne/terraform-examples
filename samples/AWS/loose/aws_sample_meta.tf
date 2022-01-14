//
// Some various examples of metadata usage and functions
//

locals {
  userIds = toset([
    "usera1",
    "usera2",
    "usera3"
  ])

  orderedList = {
    key1 = "value1"
    key3 = "value3"
    key2 = "value2"
  }
}

// Example for count processing...
resource "aws_subnet" "subnet_subnets" {
  count      = length(var.cidr_lists)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_lists[count.index]
}

// Example for for_each processing...
resource "aws_iam_user" "my_users2" {
  for_each = local.userIds
  name     = each.key
}

resource "aws_iam_user" "my_users1" {
  for_each = toset(["user1", "user2", "user3", "user4"])
  name     = each.key
}

resource "aws_iam_user" "my_users3" {
  for_each = toset([for k, v in local.orderedList : upper(v)])
  name     = each.key
}

resource "aws_subnet" "subnet_lsubnets" {
  vpc_id = aws_vpc.vpc.id

  for_each   = { for i, v in var.subnet_list : i => v }
  cidr_block = each.value.cidr
  tags = {
    Name = each.value.name
  }
}