provider "kubernetes" {
  config_context_cluster = "minikube"
}

provider "helm" {
  kubernetes {
    config_context_cluster = "minikube"
  }
}
resource "kubernetes_namespace" "nvm-db-namespace" {
  metadata {
    name = "nvm-db"
  }
}

resource "helm_release" "mysql-operator" {
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

resource "kubernetes_namespace" "prometheus-namespace" {
  metadata {
    name = "prometheus"
  }
}


resource "random_password" "grafana_admin_password" {
  length  = 16
  special = false
}


resource "helm_release" "prometheus-operator" {
  depends_on = [
    kubernetes_namespace.prometheus-namespace,
    random_password.grafana_admin_password
  ]

  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "12.2.3"
  namespace  = "prometheus"
  timeout    = 360

  values = [
    <<-EOT
    grafana:
      grafana.ini:
        server:
          domain: ${var.domain}
          root_url: "${var.protocol}://${var.domain}/grafana"
          serve_from_sub_path: true
      defaultDashboardsEnabled: true
      adminPassword: ${random_password.grafana_admin_password.result}
      ingress:
        enabled: "true"
        path: /grafana
        hosts:
          - ${var.domain}
        tls: []
EOT
    ,
  ]
}

resource "helm_release" "nvm-db" {
  depends_on = [
    kubernetes_namespace.nvm-db-namespace,
    helm_release.mysql-operator
  ]

  name      = "nvm-db"
  chart     = "../helm/nvm-db"
  namespace = "nvm-db"
  timeout   = 360

}


resource "kubernetes_namespace" "nvm-namespace" {
  metadata {
    name = "nvm"
  }
}
resource "helm_release" "nvm" {
  depends_on = [
    kubernetes_namespace.nvm-namespace,
    helm_release.mysql-operator
  ]

  name      = "nvm"
  chart     = "../helm/nvm"
  namespace = "nvm"
  timeout   = 600

  set {
    name  = "ingress.host"
    value = var.domain
  }
}
