provider "kubernetes" {
  config_context_cluster = "minikube"
  config_path            = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_context_cluster = "minikube"
  }
}

module "mysql" {
  source = "./mysql"
}

# module "nginx" {
#   source = "./nginx"

#   depends_on = [
#     module.mysql
#   ]
# }


# module "cert_manager" {
#   source = "./cert-manager"

#   depends_on = [
#     module.nginx
#   ]
# }


module "nvm" {
  source = "./nvm"

  depends_on = [
    module.mysql
  ]

  domain   = var.domain
  protocol = var.protocol

  mysql_boilerplate_password = module.mysql.mysql_boilerplate_password
}


module "prometheus_operator" {
  source = "./prometheus-operator"

  depends_on = [
    module.nvm
  ]

  domain   = var.domain
  protocol = var.protocol
}
