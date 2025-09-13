terraform {
  required_version = ">= 1.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12.0"
    }

    # https://registry.terraform.io/providers/opensearch-project/opensearch/latest
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = ">= 2.3.2"
    }


    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
