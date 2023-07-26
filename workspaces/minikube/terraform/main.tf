module "mysql" {
  source = "../../common/terraform/mysql"
}

module "nvm" {
  source = "../../common/terraform/nvm"

  depends_on = [
    module.mysql
  ]

  domain   = var.domain
  protocol = var.protocol

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password
}

module "prometheus" {
  source = "../../common/terraform/prometheus"

  depends_on = [
    module.nvm
  ]

  domain   = var.domain
  protocol = var.protocol
}
