
resource "random_password" "mysql_boilerplate_password" {
  length  = 32
  special = false
}

resource "kubernetes_config_map" "initialise_config" {
  depends_on = [helm_release.mysql_innodbcluster]

  metadata {
    name      = "initialise-config"
    namespace = "mysql"
  }

  data = {
    "initialise.sh" = file("${path.module}/innodbcluster/initialise.sh")
  }
}

# This job will be executed once MySQL is available to bootstrap the database. The job will create a new user/database.
resource "kubernetes_job" "initialise_mysql" {
  depends_on = [
    helm_release.mysql_innodbcluster,
    random_password.mysql_boilerplate_password,
    kubernetes_config_map.initialise_config
  ]

  metadata {
    name      = "initialisation"
    namespace = "mysql"
  }

  spec {
    template {
      metadata {}
      spec {
        volume {
          name = "initialise-sh"
          config_map {
            name         = "initialise-config"
            default_mode = "0755"
          }
        }
        container {
          name  = "initialisation"
          image = "alpine:3.17"
          volume_mount {
            mount_path = "/tmp/initialise.sh"
            name       = "initialise-sh"
            sub_path   = "initialise.sh"
          }
          command = [
            "/tmp/initialise.sh"
          ]
          env {
            name  = "MYSQL_HOST"
            value = "mysql-innodbcluster.mysql.svc.cluster.local"
          }
          env {
            name  = "MYSQL_PORT"
            value = 6446
          }
          env {
            name  = "MYSQL_ROOT_USER"
            value = "root"
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = random_password.mysql_root_password.result
          }

          env {
            name  = "NEW_MYSQL_USER"
            value = "boilerplate"
          }
          env {
            name  = "NEW_MYSQL_USER_PASSWORD"
            value = random_password.mysql_boilerplate_password.result
          }
          env {
            name  = "NEW_MYSQL_DATABASE"
            value = "boilerplate"
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
  timeouts {
    create = "5m"
    update = "5m"
  }

}
