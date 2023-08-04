resource "kubernetes_namespace" "ingress" {
  count = var.ingress_class_name == "nginx" ? 1 : 0
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "nginx" {
  count = var.ingress_class_name == "nginx" ? 1 : 0

  depends_on = [
    kubernetes_namespace.ingress
  ]

  name       = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"
  namespace  = kubernetes_namespace.ingress[0].metadata[0].name

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
  count = var.ingress_class_name == "nginx" ? 1 : 0

  depends_on = [helm_release.nginx]

  metadata {
    name      = "${helm_release.nginx[0].metadata[0].name}-${helm_release.nginx[0].namespace}-controller"
    namespace = kubernetes_namespace.ingress[0].metadata[0].name
  }
}
