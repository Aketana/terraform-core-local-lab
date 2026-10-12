terraform {
  required_version = ">= 1.3.0"
}

variable "environment" {
  type    = string
  default = "uat"
}

variable "subnets" {
  type = map(object({
    az   = string
    cidr = string
  }))

  default = {
    public-a = {
      az   = "ap-southeast-1a"
      cidr = "10.10.1.0/24"
    }
    private-a = {
      az   = "ap-southeast-1a"
      cidr = "10.10.11.0/24"
    }
    private-b = {
      az   = "ap-southeast-1b"
      cidr = "10.10.12.0/24"
    }
  }
}

locals {
  common_tags = {
    Project     = "infra-learning"
    Environment = var.environment
    ManagedBy   = "Terraform"
  } 
}

module "naming" {
  source       = "./modules/naming"
  project_name = local.common_tags.Project
  environment  = var.environment
}

output "resource_prefix" {
  value = module.naming.resource_name
}

output "subnet_plan" {
  value = {
    for subnet_key, subnet in var.subnets :
    subnet_key => merge(subnet, {
      name = "${module.naming.resource_name}-${subnet_key}"
      tags = local.common_tags
    })
  }
}