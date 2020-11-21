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

resource "helm_release" "mysql-cluster" {
  depends_on = [
    kubernetes_namespace.nvm-db-namespace
  ]

  name       = "presslabs"
  repository = "https://presslabs.github.io/charts"
  chart      = "mysql-operator"
  version    = "0.4.0"
  namespace  = "nvm-db"
  timeout    = 360
}

resource "helm_release" "nvm-db" {
  depends_on = [
    kubernetes_namespace.nvm-db-namespace,
    helm_release.mysql-cluster
  ]

  name      = "nvm-db"
  chart     = "../helm/nvm-db"
  namespace = "nvm-db"
  timeout   = 360

}

resource "helm_release" "nvm" {
  depends_on = [
    kubernetes_namespace.nvm-namespace,
    helm_release.nvm-db
  ]

  name      = "nvm"
  chart     = "../helm/nvm"
  namespace = "nvm"
  timeout   = 600

  set {
    name  = "cluster.enabled"
    value = "true"
  }
}
