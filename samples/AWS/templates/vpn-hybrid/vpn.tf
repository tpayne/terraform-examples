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

resource "aws_customer_gateway" "onprem_vpn_gateway" {
  device_name = "${var.project}-feopgw-001"
  bgp_asn     = var.peer_asn
  ip_address  = var.onprem_gateway_ip
  type        = "ipsec.1"
  tags        = var.tags
}

# Network gateway...
resource "aws_vpn_gateway" "bvng001" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

module "vpn_gateway" {
  source = "terraform-aws-modules/vpn-gateway/aws"

  vpn_gateway_id      = aws_vpn_gateway.bvng001.id
  customer_gateway_id = aws_customer_gateway.onprem_vpn_gateway.id
  vpc_id              = aws_vpc.vpc.id

  # tunnel inside cidr & preshared keys (optional)
  tunnel1_preshared_key = var.vpn_shared_key
  tunnel2_preshared_key = var.vpn_shared_key
}

