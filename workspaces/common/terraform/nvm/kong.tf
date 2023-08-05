locals {
  kong_app_root_response_transfomer = templatefile("${path.module}/templates/app-root-response-transformer.tmpl", {
    protocol = var.protocol
    domain   = var.domain
  })
  kong_app_root_termination = templatefile("${path.module}/templates/app-root-termination.tmpl", {
    protocol = var.protocol
    domain   = var.domain
  })
}

resource "kubectl_manifest" "kong_app_root_response_transfomer" {
  count = var.ingress_class_name == "kong" ? 1 : 0

  yaml_body = local.kong_app_root_response_transfomer
}

resource "kubectl_manifest" "kong_app_root_termination" {
  count = var.ingress_class_name == "kong" ? 1 : 0

  yaml_body = local.kong_app_root_termination
}
