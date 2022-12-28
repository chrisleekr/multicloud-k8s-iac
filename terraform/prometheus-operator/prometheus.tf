resource "kubernetes_namespace" "prometheus_namespace" {
  metadata {
    name = "prometheus"
  }
}


resource "random_password" "grafana_admin_password" {
  length  = 16
  special = false
}


resource "helm_release" "prometheus_operator" {
  depends_on = [
    kubernetes_namespace.prometheus_namespace,
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
