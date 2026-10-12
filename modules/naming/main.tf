variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

locals {
  resource_name = "${var.project_name}-${var.environment}"
}

output "resource_name" {
  value = local.resource_name
}