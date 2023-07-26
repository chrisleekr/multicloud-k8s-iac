resource "helm_release" "cert_manager" {
  depends_on = [
    kubernetes_namespace.ingress
  ]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.12.2"
  namespace  = kubernetes_namespace.ingress.metadata[0].name

  set {
    name  = "installCRDs"
    value = "true"
  }
}

