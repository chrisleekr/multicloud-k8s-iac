variable "protocol" {
  description = "HTTP protocol"
  type        = string
  default     = "http"
}

variable "domain" {
  description = "Domain Name"
  type        = string
  default     = "nvm-boilerplate.local"
}

variable "ingress_class_name" {
  description = "Ingress type"
  type        = string
  default     = "nginx"
}
