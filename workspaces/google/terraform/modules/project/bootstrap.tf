module "bootstrap" {
  source = "../../../../common/terraform/bootstrap"

  depends_on = [
    module.mysql,
    helm_release.nginx,
    helm_release.cert_manager
  ]

  cluster_issuer_create        = true
  cluster_issuer_email         = "support@${var.domain}"
  cluster_issuer_ingress_class = var.ingress_class_name
}
