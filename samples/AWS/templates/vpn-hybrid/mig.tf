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
# Create compute resources...
##############################

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

#------------------------------
# Backend resources...
#------------------------------
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html
resource "aws_launch_template" "migtemplate" {
  name_prefix   = var.project
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  network_interfaces {
    subnet_id = aws_subnet.backend_subnet.id
  }
  user_data = filebase64(format("%s/templates/startup.sh.tpl", path.module))
  tags      = var.tags
}

resource "aws_autoscaling_group" "bemig" {
  name               = var.project
  availability_zones = ["${var.region_be}a"]
  desired_capacity   = var.size
  max_size           = var.size
  min_size           = var.size
  target_group_arns  = module.internal-lb.target_arns
  launch_template {
    id      = aws_launch_template.migtemplate.id
    version = "$Latest"
  }
}



