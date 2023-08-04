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
  kong_correlation_id = templatefile("${path.module}/kong-ingress/correlation-id.tmpl", {})
  kong_prometheus     = templatefile("${path.module}/kong-ingress/prometheus.tmpl", {})
  kong_app_root_response_transfomer = templatefile("${path.module}/kong-ingress/app-root-response-transformer.tmpl", {
    protocol = var.protocol
    domain   = var.domain
  })
  kong_app_root_termination = templatefile("${path.module}/kong-ingress/app-root-termination.tmpl", {
    protocol = var.protocol
    domain   = var.domain
  })
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


resource "kubectl_manifest" "kong_app_root_response_transfomer" {
  depends_on = [
    kubernetes_namespace.kong_namespace,
    helm_release.kong,
    module.nvm
  ]
  yaml_body = local.kong_app_root_response_transfomer
}

resource "kubectl_manifest" "kong_app_root_termination" {
  depends_on = [
    kubernetes_namespace.kong_namespace,
    helm_release.kong,
    module.nvm
  ]
  yaml_body = local.kong_app_root_termination
}
