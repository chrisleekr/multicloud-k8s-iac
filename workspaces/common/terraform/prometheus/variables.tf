variable "protocol" {
  description = "HTTP protocol"
  type        = string
}

variable "domain" {
  description = "Domain Name"
  type        = string
}


variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}
