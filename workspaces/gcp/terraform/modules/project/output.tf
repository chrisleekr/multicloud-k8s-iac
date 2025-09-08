output "mysql_root_password" {
  value       = module.mysql.mysql_root_password
  description = "MySQL root password"
  sensitive   = true
}

output "mysql_boilerplate_password" {
  value       = module.mysql.mysql_boilerplate_password
  description = "MySQL boilerplate password"
  sensitive   = true
}

output "grafana_admin_password" {
  value       = module.prometheus.grafana_admin_password
  description = "Grafana admin password"
  sensitive   = true
}
