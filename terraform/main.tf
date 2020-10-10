provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_namespace" "nvm-namespace" {
  metadata {
    name = "nvm"
  }
}
resource "kubernetes_namespace" "nvm-db-namespace" {
  metadata {
    name = "nvm-db"
  }
}

provider "helm" {
  kubernetes {
    config_context_cluster = "minikube"
  }
}

resource "helm_release" "local" {
  name      = "nvm"
  chart     = "../helm/nvm"
  namespace = "nvm"
  timeout   = 300

  set {
    name  = "cluster.enabled"
    value = "true"
  }
}
