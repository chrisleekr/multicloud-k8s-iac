terraform {
  required_version = ">= 1.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.7.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Assume role to deploy infrastructure rather than the user having powerful permissions.
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/infrastructure-deployer-role"
  }

  default_tags {
    tags = var.default_tags
  }
}
