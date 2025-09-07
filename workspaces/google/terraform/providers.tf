terraform {
  required_version = ">= 1.13.1"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.1.1"
    }

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

provider "google" {
  region                = var.google_region
  user_project_override = true
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
  kubernetes = {
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
