
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
      "${path.module}/kong-ingress/values.tmpl",
      {
        hostname = var.domain
      }
    )
  ]
}


locals {
  correlation_id = templatefile("${path.module}/kong-ingress/correlation-id.tmpl", {})
}

resource "kubernetes_manifest" "correlation_id" {
  manifest = yamldecode(local.correlation_id)
}
