
resource "kubernetes_namespace" "mysql_namespace" {
  metadata {
    name = "mysql"
  }
}

resource "random_password" "mysql_root_password" {
  length  = 32
  special = false
}


resource "helm_release" "mysql_innodbcluster" {
  depends_on = [
    kubernetes_namespace.mysql_namespace,
    helm_release.mysql_operator
  ]

  name       = "mysql-innodbcluster"
  repository = "https://mysql.github.io/mysql-operator"
  chart      = "mysql-innodbcluster"
  version    = "2.1.0"
  namespace  = "mysql"
  timeout    = 360

  values = [
    templatefile(
      "${path.module}/innodbcluster/values.tmpl",
      {
        credentials_root_password = random_password.mysql_root_password.result

        server_instances                = var.server_instances
        router_instances                = var.router_instances
        mysql_resources_requests_memory = var.mysql_resources_requests_memory
        mysql_resources_requests_cpu    = var.mysql_resources_requests_cpu
        mysql_resources_limits_memory   = var.mysql_resources_limits_memory
        mysql_resources_limits_cpu      = var.mysql_resources_limits_cpu
      }
    ),
  ]
}

