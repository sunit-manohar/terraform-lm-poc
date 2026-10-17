
variable "aws_region" {
  type        = string
  description = "AWS region containing the EC2 instance"
}

variable "instance_id" {
  type        = string
  description = "Existing EC2 instance ID"
}
