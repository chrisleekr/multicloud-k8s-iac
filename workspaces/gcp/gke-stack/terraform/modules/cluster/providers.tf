terraform {
  required_version = ">= 1.13.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.1.1"
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
