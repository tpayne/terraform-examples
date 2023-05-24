
resource "null_resource" "print-vars" {

  triggers = {
    param1 = var.param1
    param2 = var.param2
    param3 = var.param3
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    working_dir = path.module
    command     = <<-EOT
      scripts/print.sh \
        --param1 "${self.triggers.param1}" \
        --param2 "${self.triggers.param2}" \
        --param3 "${self.triggers.param3}" \
    EOT
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/sh", "-c"]
    working_dir = path.module
    command     = <<-EOT
      scripts/print.sh \
        --param1 "${self.triggers.param1}" \
        --param2 "${self.triggers.param2}" \
        --param3 "${self.triggers.param3}" \
    EOT
  }
}

