variable "cluster_issuer_create" {
  description = "Set a boolean to create ClusterIssuer"
  type        = bool
  default     = false
}

variable "cluster_issuer_email" {
  description = "Email address of ClusterIssuer"
  type        = string
  default     = "support@boilerplate.local"
}

variable "cluster_issuer_ingress_class" {
  description = "Ingress class of ClusterIssuer"
  type        = string
  default     = "nginx"
}
