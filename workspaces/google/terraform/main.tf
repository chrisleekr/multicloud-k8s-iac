module "cluster" {
  source = "./modules/cluster"

  google_project_id   = var.google_project_id
  google_region       = var.google_region
  google_cluster_name = var.google_cluster_name
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
