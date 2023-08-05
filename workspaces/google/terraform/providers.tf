terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.74.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "google" {
  project = var.google_project_id
  region  = var.google_region
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${module.cluster.kubernetes_cluster_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    module.cluster.kubernetes_cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${module.cluster.kubernetes_cluster_endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      module.cluster.kubernetes_cluster_ca_certificate
    )
  }
}

provider "kubectl" {
  host  = "https://${module.cluster.kubernetes_cluster_endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    module.cluster.kubernetes_cluster_ca_certificate
  )
  load_config_file = false
}

