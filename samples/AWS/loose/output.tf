# Output variables to stdout to show variables or expanded vars...

output "public_ip" {
  value = aws_eip.ip.public_ip
}

output "InstanceID" {
  value = aws_instance.vm01.id
}

output "WebPublicIp" {
  value = aws_instance.web.public_ip
}

output "UserIds" {
  value = {
    for k, v in aws_iam_user.my_users1 :
    k => {
      id   = v.id
      name = v.name
    }
  }
}