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
  version    = "48.1.2"
  namespace  = "prometheus"
  timeout    = 360

  values = [
    <<-EOT
    grafana:
      persistence:
        enabled: true
      defaultDashboardsEnabled: true
      dashboardProviders:
        dashboardproviders.yaml:
          apiVersion: 1
          providers:
          - name: 'default' # Configure a dashboard provider file to
            orgId: 1        # put Kong dashboard into.
            folder: ''
            type: file
            disableDeletion: false
            editable: true
            options:
              path: /var/lib/grafana/dashboards/default
      dashboards:
        default:
          kong-dash:
            gnetId: 7424  # Install the following Grafana dashboard in the
            revision: 11   # instance: https://grafana.com/dashboards/7424
            datasource: Prometheus
          kic-dash:
            gnetId: 15662
            revision: 2
            datasource: Prometheus
      grafana.ini:
        server:
          domain: ${var.domain}
          root_url: "${var.protocol}://${var.domain}/grafana"
          serve_from_sub_path: true
      adminPassword: ${random_password.grafana_admin_password.result}
      ingress:
        enabled: true
        path: /grafana
        ingressClassName: ${var.ingress_class_name}
        hosts:
          - ${var.domain}
        tls: []
    prometheus:
      prometheusSpec:
        replicas: 1
        externalUrl: "${var.protocol}://${var.domain}/prometheus"
        routePrefix: /prometheus
        scrapeInterval: 10s
      ingress:
        enabled: true
        paths:
          - /prometheus
        ingressClassName: ${var.ingress_class_name}
        hosts:
          - ${var.domain}
        tls: []
EOT
    ,
  ]
}
