
variable "google_region" {
  description = "Location of the GKE cluster"
  type        = string
  default     = "australia-southeast2" # Melbourne
}

variable "google_billing_account_id" {
  description = "Billing Account ID"
  type        = string
  default     = "012345-678910-123456"
}

variable "google_org_id" {
  description = "Organization ID"
  type        = string
  default     = "1234567890"
}

variable "google_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "sample"
}

variable "protocol" {
  description = "HTTP protocol"
  default     = "https"
}

variable "domain" {
  description = "Domain Name"
  default     = "nvm.chrislee.kr"
}

variable "ingress_class_name" {
  description = "Ingress type"
  type        = string
  default     = "nginx"
}

