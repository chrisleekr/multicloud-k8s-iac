
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
  chart     = "${path.module}/../../helm/nvm"
  namespace = "nvm"
  timeout   = 600

  lint = true

  set {
    name  = "ingress.host"
    value = var.domain
  }

  set {
    name  = "ingress.className"
    value = var.ingress_class_name
  }

  set {
    name  = "ingress.tls.enabled"
    value = var.ingress_tls_enabled
  }

  set {
    name  = "ingress.tls.secretName"
    value = var.ingress_tls_secret_name
  }

  dynamic "set" {
    for_each = var.ingress_annotations

    content {
      name  = "ingress.annotations.${replace(set.key, ".", "\\.")}"
      value = set.value
    }
  }

  set {
    name  = "environment"
    value = var.environment
  }

  set_sensitive {
    name  = "secrets.dbHost.value"
    value = "mysql-innodbcluster.mysql.svc.cluster.local"
  }

  set_sensitive {
    name  = "secrets.dbPort.value"
    value = 6446
  }

  set_sensitive {
    name  = "secrets.dbUser.value"
    value = "boilerplate"
  }

  set_sensitive {
    name  = "secrets.dbPassword.value"
    value = var.mysql_boilerplate_password
  }

  set_sensitive {
    name  = "secrets.dbName.value"
    value = "boilerplate"
  }

  set_sensitive {
    name  = "secrets.jwtSecretKey.value"
    value = random_password.jwt_secret_key.result
  }

  set_sensitive {
    name  = "secrets.jwtRefreshSecretKey.value"
    value = random_password.jwt_refresh_secret_key.result
  }

  set {
    name  = "apps.api.env.API_URL"
    value = "${var.protocol}://${var.domain}/api"
  }

  set {
    name  = "apps.api.env.API_URL"
    value = "${var.protocol}://${var.domain}/api"
  }

  set {
    name  = "apps.api.env.BACKEND_URL"
    value = "${var.protocol}://${var.domain}/backend"
  }

  set {
    name  = "apps.api.env.FRONTEND_URL"
    value = "${var.protocol}://${var.domain}/frontend-vue"
  }

  set {
    name  = "apps.api.env.EMAIL_FROM_ADDRESS"
    value = "support@${var.domain}"
  }

  set {
    name  = "apps.frontendVue.env.API_URL"
    value = "${var.protocol}://${var.domain}/api"
  }

  set {
    name  = "apps.backend.env.API_URL"
    value = "${var.protocol}://${var.domain}/api"
  }

}
