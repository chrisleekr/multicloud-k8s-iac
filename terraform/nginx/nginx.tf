
resource "kubernetes_namespace" "nginx_namespace" {
  metadata {
    name = "nginx"
  }
}
resource "helm_release" "nginx_ingress" {
  depends_on = [
    kubernetes_namespace.mysql_operator_namespace,
  ]

  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.4.0"
  namespace  = "nginx"

}


resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.10.1"
  namespace  = "nginx"

  # Install Kubernetes Custom resource definitions
  set {
    name  = "installCRDs"
    value = "true"
  }
}
