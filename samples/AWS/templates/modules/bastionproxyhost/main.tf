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
data "aws_ami" "pxyimage" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.image]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#------------------------------
# Frontend bastion host...
#------------------------------
resource "aws_launch_template" "proxytemplate" {
  name_prefix   = "pxy${var.name}"
  image_id      = data.aws_ami.pxyimage.id
  instance_type = var.machine_type

  monitoring {
    enabled = true
  }

  user_data = filebase64(var.custom_data)
  tags      = var.tags
}

resource "aws_instance" "proxyvm" {
  associate_public_ip_address = true
  availability_zone           = "${var.location}a"

  vpc_security_group_ids      = var.sgs

  subnet_id = var.subnet_id
  user_data = filebase64(var.custom_data)
  tags      = var.tags

  launch_template {
    id      = aws_launch_template.proxytemplate.id
    version = "$Latest"
  }
}


