variable "google_region" {
  description = "Location of the GKE cluster"
  type        = string
}

variable "google_org_id" {
  description = "Organization ID"
  type        = string
}

variable "google_billing_account_id" {
  description = "Billing Account ID"
  type        = string
}

variable "google_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "google_node_pool_max_nodes" {
  description = "Value of max nodes"
  type        = number
  default     = 1
}
