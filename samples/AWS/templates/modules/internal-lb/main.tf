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

resource "aws_lb" "internal-lb" {
  name               = var.name
  internal           = true
  load_balancer_type = var.type

  enable_deletion_protection = false
  tags                       = var.tags

  subnet_mapping {
    subnet_id            = var.subnet_id
    private_ipv4_address = var.subnet_ip
  }
}

resource "aws_lb_target_group" "lb-target" {
  for_each    = { for i, v in var.load_balancer_rules : i => v }
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "lb-listener" {
  for_each = { for i, v in var.load_balancer_rules : i => v }

  load_balancer_arn = aws_lb.internal-lb.id
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target[each.key].arn
  }
}


