module "mysql" {
  source = "../../common/terraform/mysql"
}

module "kong_ingress" {
  count = var.ingress_class_name == "kong" ? 1 : 0

  source = "../../common/terraform/kong-ingress"

  domain   = var.domain
  protocol = var.protocol

}

module "nvm" {
  source = "../../common/terraform/nvm"

  depends_on = [
    module.mysql,
    module.kong_ingress
  ]

  domain   = var.domain
  protocol = var.protocol

  ingress_class_name = var.ingress_class_name

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password
}

module "prometheus" {
  source = "../../common/terraform/prometheus"

  depends_on = [
    module.nvm
  ]

  domain   = var.domain
  protocol = var.protocol

  ingress_class_name = var.ingress_class_name
}
