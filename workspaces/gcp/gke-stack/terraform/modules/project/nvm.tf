module "nvm" {
  source = "../../../../../common/terraform/nvm"

  depends_on = [
    module.mysql,
    helm_release.nginx,
    helm_release.cert_manager,
    module.bootstrap,
    module.kong_ingress
  ]

  environment = "google"

  domain   = var.domain
  protocol = var.protocol

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password

  ingress_class_name      = var.ingress_class_name
  ingress_tls_enabled     = true
  ingress_tls_secret_name = "nvm-tls"
  ingress_annotations = {
    "cert-manager.io/cluster-issuer" = "letsencrypt"
  }
}
