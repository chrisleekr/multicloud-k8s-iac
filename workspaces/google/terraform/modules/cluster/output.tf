output "google_project_id" {
  description = "Google project ID"
  value       = google_project.project.id
}

output "kubernetes_cluster_name" {
  description = "GKE Cluster Name"
  value       = google_container_cluster.primary.name
}

output "kubernetes_cluster_endpoint" {
  description = "GKE Cluster Host Endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "kubernetes_cluster_ca_certificate" {
  description = "GKE Cluster CA Certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "load_balancer_ip_address" {
  description = "Load Balancer IP Address"
  value       = google_compute_address.load_balancer_ip.address
}

output "load_balancer_ip_name" {
  description = "Load Balancer IP Name"
  value       = google_compute_address.load_balancer_ip.name
}
