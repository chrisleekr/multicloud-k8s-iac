module "mysql" {
  source = "../../common/terraform/mysql"
}

module "nvm" {
  source = "../../common/terraform/nvm"

  depends_on = [
    module.mysql,
    helm_release.kong
  ]

  domain   = var.domain
  protocol = var.protocol

  ingress_class_name = "kong"

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password
}

module "prometheus" {
  source = "../../common/terraform/prometheus"

  depends_on = [
    module.nvm
  ]

  domain   = var.domain
  protocol = var.protocol

  ingress_class_name = "kong"
}
