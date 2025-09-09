terraform {
  required_version = ">= 1.13.1"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.2"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.7.2"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}


provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
