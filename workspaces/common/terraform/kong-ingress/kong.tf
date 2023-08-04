resource "kubernetes_namespace" "kong_namespace" {
  metadata {
    name = "kong"
  }
}

resource "helm_release" "kong" {
  depends_on = [
    kubernetes_namespace.kong_namespace
  ]

  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.25.0"
  namespace  = "kong"
  timeout    = 360

  values = [
    templatefile(
      "${path.module}/templates/values.tmpl",
      {

        hostname = var.domain
      }
    )
  ]
}

locals {
  kong_correlation_id = templatefile("${path.module}/templates/correlation-id.tmpl", {})
  kong_prometheus     = templatefile("${path.module}/templates/prometheus.tmpl", {})
}

resource "kubectl_manifest" "kong_correlation_id" {
  depends_on = [
    kubernetes_namespace.kong_namespace,
    helm_release.kong
  ]
  yaml_body = local.kong_correlation_id
}

resource "kubectl_manifest" "kong_prometheus" {
  depends_on = [
    kubernetes_namespace.kong_namespace,
    helm_release.kong
  ]
  yaml_body = local.kong_prometheus
}
