module "kong_ingress" {
  count = var.ingress_class_name == "kong" ? 1 : 0

  source = "../../../../../common/terraform/kong-ingress"

  domain = var.domain
  # protocol = var.protocol

  load_balancer_ip_address = var.load_balancer_ip_address
}
