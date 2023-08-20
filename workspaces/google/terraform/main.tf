module "cluster" {
  source = "./modules/cluster"

  google_region             = var.google_region
  google_org_id             = var.google_org_id
  google_cluster_name       = var.google_cluster_name
  google_billing_account_id = var.google_billing_account_id
}

module "project" {
  depends_on = [
    module.cluster
  ]

  source = "./modules/project"

  protocol = var.protocol
  domain   = var.domain

  ingress_class_name = var.ingress_class_name

  load_balancer_ip_address = module.cluster.load_balancer_ip_address
}
