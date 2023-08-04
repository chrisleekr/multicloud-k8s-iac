module "prometheus" {
  source = "../../../../common/terraform/prometheus"

  depends_on = [
    module.nvm
  ]

  domain   = var.domain
  protocol = var.protocol

  ingress_class_name = var.ingress_class_name
}
