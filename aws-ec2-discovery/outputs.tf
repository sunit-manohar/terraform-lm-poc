
output "ec2_instance_id" {
  value = data.aws_instance.existing.id
}

output "ec2_private_ip" {
  value = data.aws_instance.existing.private_ip
}

output "ec2_state" {
  value = data.aws_instance.existing.instance_state
}

output "ec2_ami" {
  value = data.aws_instance.existing.ami
}
