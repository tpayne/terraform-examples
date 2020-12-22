# Output variables to stdout to show variables or expanded vars...

output "public_ip" {
  value = aws_eip.ip.public_ip
}

output "InstanceID" {
  value = aws_instance.vm01.id
}

