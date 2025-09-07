
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

  set = concat(
    [
      {
        name  = "ingress.host"
        value = var.domain
      },
      {
        name  = "ingress.className"
        value = var.ingress_class_name
      },
      {
        name  = "ingress.tls.enabled"
        value = var.ingress_tls_enabled
      },
      {
        name  = "ingress.tls.secretName"
        value = var.ingress_tls_secret_name
      },
      {
        name  = "environment"
        value = var.environment
      },
      {
        name  = "apps.api.env.API_URL"
        value = "${var.protocol}://${var.domain}/api"
      },
      {
        name  = "apps.api.env.API_URL"
        value = "${var.protocol}://${var.domain}/api"
      },
      {
        name  = "apps.api.env.BACKEND_URL"
        value = "${var.protocol}://${var.domain}/backend"
      },
      {
        name  = "apps.api.env.FRONTEND_URL"
        value = "${var.protocol}://${var.domain}/frontend-vue"
      },
      {
        name  = "apps.api.env.EMAIL_FROM_ADDRESS"
        value = "support@${var.domain}"
      },
      {
        name  = "apps.frontendVue.env.API_URL"
        value = "${var.protocol}://${var.domain}/api"
      },
      {
        name  = "apps.backend.env.API_URL"
        value = "${var.protocol}://${var.domain}/api"
      }
    ],
    [
      for key, value in var.ingress_annotations : {
        name  = "ingress.annotations.${replace(key, ".", "\\.")}"
        value = value
      }
    ]
  )


  set_sensitive = [
    {
      name  = "secrets.dbHost.value"
      value = "mysql-innodbcluster.mysql.svc.cluster.local"
    },
    {
      name  = "secrets.dbPort.value"
      value = 6446
    },
    {
      name  = "secrets.dbUser.value"
      value = "boilerplate"
    },
    {
      name  = "secrets.dbPassword.value"
      value = var.mysql_boilerplate_password
    },
    {
      name  = "secrets.dbName.value"
      value = "boilerplate"
    },
    {
      name  = "secrets.jwtSecretKey.value"
      value = random_password.jwt_secret_key.result
    },
    {
      name  = "secrets.jwtRefreshSecretKey.value"
      value = random_password.jwt_refresh_secret_key.result
    }
  ]


  # dynamic "set" {
  #   for_each = var.ingress_annotations

  #   content {
  #     name  = "ingress.annotations.${replace(set.key, ".", "\\.")}"
  #     value = set.value
  #   }
  # }
}
