terraform {
  required_version = ">= 1.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.7.2"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}
