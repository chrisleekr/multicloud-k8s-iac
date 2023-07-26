resource "kubernetes_namespace" "mysql_operator_namespace" {
  metadata {
    name = "mysql-operator"
  }
}

resource "helm_release" "mysql_operator" {
  depends_on = [
    kubernetes_namespace.mysql_operator_namespace,
  ]

  name       = "mysql-operator"
  repository = "https://mysql.github.io/mysql-operator"
  chart      = "mysql-operator"
  version    = "2.0.10"
  namespace  = "mysql-operator"
  timeout    = 360
}
