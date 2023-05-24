/**
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

# This section will declare the providers needed...
# terraform init -upgrade
# DEBUG - export TF_LOG=DEBUG

##############################
# Create network interfaces...
##############################
resource "aws_internet_gateway" "fgw" {
  vpc_id = aws_vpc.fevnet.id
  tags   = var.tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.bevnet.id
  tags   = var.tags
}

#------------------------------
# Frontend network resources...
#------------------------------

# Create a frontend VPC network...
resource "aws_vpc" "fevnet" {
  cidr_block           = var.frontend_cidr_range
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_route_table" "rtb_frontend" {
  vpc_id = aws_vpc.fevnet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fgw.id
  }
}

resource "aws_subnet" "frontend_subnet" {
  vpc_id            = aws_vpc.fevnet.id
  cidr_block        = var.frontendsn_cidr_range
  availability_zone = "${var.region_fe}a"
}

resource "aws_route_table_association" "rta_subnet_frontend" {
  subnet_id      = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.rtb_frontend.id
}

# Firewall rules
resource "aws_security_group" "fsg" {
  name   = "fesg001"
  vpc_id = aws_vpc.fevnet.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#------------------------------
# Backend network resources...
#------------------------------

# Create a backend virtual network...
resource "aws_vpc" "bevnet" {
  cidr_block           = var.backend_cidr_range
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "backend_subnet" {
  vpc_id            = aws_vpc.bevnet.id
  cidr_block        = var.backendsn_cidr_range
  availability_zone = "${var.region_be}a"
}

# Firewall rules
resource "aws_route_table" "rtb_backend" {
  vpc_id = aws_vpc.bevnet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta_subnet_backend" {
  subnet_id      = aws_subnet.backend_subnet.id
  route_table_id = aws_route_table.rtb_backend.id
}

# Firewall rules
resource "aws_security_group" "bsg" {
  name   = "besg001"
  vpc_id = aws_vpc.bevnet.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.backendsn_cidr_range]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.backendsn_cidr_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Peering rules
resource "aws_vpc_peering_connection" "frontend_backend_peering" {
  peer_vpc_id = aws_vpc.fevnet.id
  vpc_id      = aws_vpc.bevnet.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}


