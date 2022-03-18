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
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

#------------------------------
# Backend network resources...
#------------------------------

# Create a backend virtual network...
resource "aws_vpc" "vpc" {
  cidr_block           = var.backend_cidr_range
  enable_dns_support   = true
  enable_dns_hostnames = true
}


# Subnet backend layer
resource "aws_subnet" "backend_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.backendsn_cidr_range
  availability_zone = "${var.region_be}a"
}

resource "aws_subnet" "begateway_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.backendvpn_cidr_range
  availability_zone = "${var.region_be}a"
}

# Firewall rules
resource "aws_network_acl" "bnsg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    rule_no    = 1001
    action     = "allow"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = var.backend_cidr_range
  }

  ingress {
    rule_no    = 1002
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = var.backend_cidr_range
  }
}

resource "aws_network_acl_association" "bensgass001" {
  network_acl_id = aws_network_acl.bnsg.id
  subnet_id      = aws_subnet.backend_subnet.id
}




