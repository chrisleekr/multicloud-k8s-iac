terraform {
  required_version = "~> 1.3.6"

  # Note that minikube cannot be worked with Terraform Cloud.
  #
  # cloud {
  #   organization = "chrisleekr" # Replace with your organisation from app.

  #   workspaces {
  #     name = "k8s-nvm-boilerplate" # Replace with your workspace name
  #   }
  # }


  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }
}


provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}
