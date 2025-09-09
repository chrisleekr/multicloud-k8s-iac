module "mysql" {
  source = "../../../../../common/terraform/mysql"

  server_instances                = 1
  router_instances                = 1
  mysql_resources_requests_memory = "512Mi"
  mysql_resources_requests_cpu    = "256m"
  mysql_resources_limits_memory   = "1Gi"
  mysql_resources_limits_cpu      = "1"
}
