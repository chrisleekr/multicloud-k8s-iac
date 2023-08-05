resource "helm_release" "kong" {
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.25.0"
  namespace  = "ingress"
  timeout    = 360

  values = [
    templatefile(
      "${path.module}/templates/values.tmpl",
      {
        hostname                 = var.domain
        load_balancer_ip_address = var.load_balancer_ip_address
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
    helm_release.kong
  ]
  yaml_body = local.kong_correlation_id
}

resource "kubectl_manifest" "kong_prometheus" {
  depends_on = [
    helm_release.kong
  ]
  yaml_body = local.kong_prometheus
}
