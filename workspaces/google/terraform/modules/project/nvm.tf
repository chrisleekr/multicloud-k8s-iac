module "nvm" {
  source = "../../../../common/terraform/nvm"

  depends_on = [
    module.mysql,
    helm_release.nginx,
    helm_release.cert_manager,
    module.bootstrap
  ]

  environment = "google"

  domain   = var.domain
  protocol = var.protocol

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password

  ingress_class_name      = "nginx"
  ingress_tls_enabled     = true
  ingress_tls_secret_name = "nvm-tls"
  ingress_annotations = {
    "cert-manager.io/cluster-issuer" = "letsencrypt"
  }

}
