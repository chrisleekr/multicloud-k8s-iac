variable "google_project_id" {
  description = "ID of the Google project"
  type        = string
}

variable "google_region" {
  description = "Location of the GKE cluster"
  type        = string
  default     = "australia-southeast2" # Melbourne
}

variable "google_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "sample-cluster"
}

variable "protocol" {
  description = "HTTP protocol"
  default     = "https"
}

variable "domain" {
  description = "Domain Name"
  default     = "nvm.chrislee.kr"
}
