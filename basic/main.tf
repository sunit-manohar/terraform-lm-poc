terraform {
  required_version = ">= 1.4.0"
}

variable "environment" {
  description = "Environment label to include in the test resource."
  type        = string
  default     = "poc"
}

resource "terraform_data" "hello" {
  input = {
    message     = "Hello from LogicMonitor Terraform POC"
    environment = var.environment
  }
}

output "message" {
  value = terraform_data.hello.output.message
}

output "environment" {
  value = terraform_data.hello.output.environment
}
