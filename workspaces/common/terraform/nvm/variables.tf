variable "environment" {
  description = "Cluster environment name such as minikube, google"
  type        = string
  default     = "minikube"
}

variable "protocol" {
  description = "HTTP protocol"
  type        = string
}

variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "mysql_boilerplate_password" {
  description = "Password of MySQL boilerplate user"
  type        = string
  sensitive   = true
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "ingress_tls_enabled" {
  description = "Ingress TLS enabled"
  type        = bool
  default     = false
}

variable "ingress_tls_secret_name" {
  description = "Secret name of Ingress TLS"
  type        = string
  default     = "nvm-tls"
}

variable "ingress_annotations" {
  description = "Annotations of Ingress"
  type        = map(string)
  default     = {}
}
