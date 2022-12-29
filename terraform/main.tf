module "mysql" {
  source = "./mysql"
}

module "nvm" {
  source = "./nvm"

  depends_on = [
    module.mysql
  ]

  domain   = var.domain
  protocol = var.protocol

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password
}

module "prometheus" {
  source = "./prometheus"

  depends_on = [
    module.nvm
  ]

  domain   = var.domain
  protocol = var.protocol
}
