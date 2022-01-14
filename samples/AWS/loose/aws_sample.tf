resource "aws_instance" "vm01" {
  ami           = "ami-830c94e3"
  instance_type = var.machine_types.dev
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.vm01.id
}

