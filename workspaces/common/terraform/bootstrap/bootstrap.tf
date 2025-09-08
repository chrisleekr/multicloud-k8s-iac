resource "helm_release" "nvm" {
  name    = "bootstrap"
  chart   = "${path.module}/../../helm/bootstrap"
  timeout = 600

  lint = true

  set = [
    {
      name  = "clusterIssuer.create"
      value = var.cluster_issuer_create
    },
    {
      name  = "clusterIssuer.email"
      value = var.cluster_issuer_email
    },
    {
      name  = "clusterIssuer.ingressClass"
      value = var.cluster_issuer_ingress_class
    }
  ]
}
