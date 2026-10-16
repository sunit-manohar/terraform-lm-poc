terraform {
  required_version = ">= 1.4.0"
}

variable "linux_host" {
  description = "DNS name or IP address of the Linux test machine reachable from the Terraform runner."
  type        = string
}

variable "ssh_user" {
  description = "Linux SSH username (e.g. ec2-user or ubuntu)."
  type        = string
  default     = "ec2-user"
}

variable "ssh_private_key" {
  description = "PEM-encoded private key content. Set as a sensitive HCP Terraform workspace variable. Never commit it to Git."
  type        = string
  sensitive   = true
}

variable "ssh_host_key" {
  description = "Trusted SSH host public key line (e.g. ssh-ed25519 AAAA...), obtained and verified out-of-band."
  type        = string
}

variable "execution_id" {
  description = "Change this value to explicitly request another execution."
  type        = string
  default     = "run-001"
}

resource "terraform_data" "linux_check" {
  triggers_replace = [var.execution_id]

  connection {
    type        = "ssh"
    host        = var.linux_host
    user        = var.ssh_user
    private_key = var.ssh_private_key
    host_key    = var.ssh_host_key
    timeout     = "30s"
  }

  provisioner "remote-exec" {
    inline = [
      "set -eu",
      "echo 'LogicMonitor Terraform SSH test'",
      "hostname",
      "uname -s",
      "id -un",
      "date -u"
    ]
  }
}

output "target_linux_host" {
  value = var.linux_host
}

output "execution_id" {
  value = var.execution_id
}
