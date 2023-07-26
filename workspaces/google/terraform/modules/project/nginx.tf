resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "nginx" {
  depends_on = [
    kubernetes_namespace.ingress
  ]

  name       = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"
  namespace  = kubernetes_namespace.ingress.metadata[0].name

  # https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
  values = [
    <<-EOF
    controller:
      service:
        loadBalancerIP: "${var.load_balancer_ip_address}"
EOF
  ]

}

data "kubernetes_service" "nginx_ingress_controller" {
  depends_on = [helm_release.nginx]

  metadata {
    name      = "${helm_release.nginx.metadata[0].name}-${helm_release.nginx.namespace}-controller"
    namespace = kubernetes_namespace.ingress.metadata[0].name
  }
}
