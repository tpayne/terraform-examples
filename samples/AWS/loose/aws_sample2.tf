# This sample has been adapted from the Terraform standard examples for getting started
# https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started

# Create VPC and subnets...
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
}

// Example for count processing...
resource "aws_subnet" "subnet_subnets" {
  count      = length(var.cidr_lists)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_lists[count.index]
}

locals {
  userIds = toset([
    "usera1",
    "usera2",
    "usera3"
  ])
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


resource "aws_subnet" "subnet_lsubnets" {
  vpc_id = aws_vpc.vpc.id

  for_each   = { for i, v in var.subnet_list : i => v }
  cidr_block = each.value.cidr
  tags = {
    Name = each.value.name
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "sg_22_80" {
  name   = "sg_22"
  vpc_id = aws_vpc.vpc.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IGW...
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Select image of use...
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# What to do on an instance...
data "template_file" "user_data" {
  template = file("app-web-app.yml")
}

# Create a AWS instance and install packages and users on it...
# ssh terraform@$(echo "aws_instance.web.public_ip" | terraform console) 
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_22_80.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered
}