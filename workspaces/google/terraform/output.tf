
output "kubernetes_cluster_name" {
  value       = module.cluster.kubernetes_cluster_name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_endpoint" {
  value       = module.cluster.kubernetes_cluster_endpoint
  description = "GKE Cluster Host"
}

output "load_balancer_ip_address" {
  value       = module.cluster.load_balancer_ip_address
  description = "Load Balancer IP Address"
}

output "load_balancer_ip_name" {
  value       = module.cluster.load_balancer_ip_name
  description = "Load Balancer IP Name"
}

output "mysql_root_password" {
  value       = module.project.mysql_root_password
  description = "MySQL root password"
  sensitive   = true
}

output "mysql_boilerplate_password" {
  value       = module.project.mysql_boilerplate_password
  description = "MySQL boilerplate password"
  sensitive   = true
}

output "grafana_admin_password" {
  value       = module.project.grafana_admin_password
  description = "Grafana admin password"
  sensitive   = true
}
