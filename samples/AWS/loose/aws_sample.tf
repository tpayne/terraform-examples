resource "aws_instance" "vm01" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.machine_types.dev
  subnet_id     = aws_subnet.subnet_public.id
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.vm01.id
}

