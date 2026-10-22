variable "environment" {
  type    = string
  default = "dev"
}

variable "subnets" {
  type = map(object({
    az   = string
    cidr = string
    tier = string
  }))

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      contains(["public", "private"], subnet.tier)
    ])
    error_message = "subnets.tier ต้องเป็น public หรือ private เท่านั้น"
  }

  default = {
    public-a = {
      az   = "ap-southeast-1a"
      cidr = "10.10.1.0/24"
      tier = "public"
    }

    private-a = {
      az   = "ap-southeast-1a"
      cidr = "10.10.11.0/24"
      tier = "private"
    }

    private-b = {
      az   = "ap-southeast-1b"
      cidr = "10.10.12.0/24"
      tier = "private"
    }

    private-d = {
      az   = "ap-southeast-1b"
      cidr = "10.10.14.0/24"
      tier = "private"
    }
  }
}

locals {
  common_tags = {
    Project     = "infra-learning"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  public_subnets = {
    for subnet_key, subnet in var.subnets :
    subnet_key => subnet
    if subnet.tier == "public"
  }

  private_subnets = {
    for subnet_key, subnet in var.subnets :
    subnet_key => subnet
    if subnet.tier == "private"
  }
}

output "public_subnet_keys" {
  value = keys(local.public_subnets)
}

output "private_subnet_keys" {
  value = keys(local.private_subnets)
}