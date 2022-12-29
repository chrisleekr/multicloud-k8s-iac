
resource "kubernetes_namespace" "nvm_namespace" {
  metadata {
    name = "nvm"
  }
}


resource "random_password" "jwt_secret_key" {
  length  = 32
  special = false
}

resource "random_password" "jwt_refresh_secret_key" {
  length  = 32
  special = false
}


resource "helm_release" "nvm" {
  depends_on = [
    kubernetes_namespace.nvm_namespace
  ]

  name      = "nvm"
  chart     = "../helm/nvm"
  namespace = "nvm"
  # timeout   = 600

  set {
    name  = "ingress.host"
    value = var.domain
  }

  set {
    name  = "secrets[0].key"
    value = "db-host"
  }
  set_sensitive {
    name  = "secrets[0].value"
    value = "mysql-innodbcluster.mysql.svc.cluster.local"
  }

  set {
    name  = "secrets[1].key"
    value = "db-port"
  }
  set_sensitive {
    name  = "secrets[1].value"
    value = 6446
  }

  set {
    name  = "secrets[2].key"
    value = "db-user"
  }
  set_sensitive {
    name  = "secrets[2].value"
    value = "boilerplate"
  }

  set {
    name  = "secrets[3].key"
    value = "db-password"
  }
  set_sensitive {
    name  = "secrets[3].value"
    value = var.mysql_boilerplate_password
  }

  set {
    name  = "secrets[4].key"
    value = "db-name"
  }
  set_sensitive {
    name  = "secrets[4].value"
    value = "boilerplate"
  }

  set {
    name  = "secrets[5].key"
    value = "jwt-secret-key"
  }
  set_sensitive {
    name  = "secrets[5].value"
    value = random_password.jwt_secret_key.result
  }

  set {
    name  = "secrets[6].key"
    value = "jwt-refresh-secret-key"
  }
  set_sensitive {
    name  = "secrets[6].value"
    value = random_password.jwt_refresh_secret_key.result
  }

}
