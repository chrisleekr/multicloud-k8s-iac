variable "protocol" {
  description = "HTTP protocol"
  type        = string
}

variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "load_balancer_ip_address" {
  description = "Load Balancer IP Address"
  type        = string
}

variable "ingress_class_name" {
  description = "Ingress type"
  type        = string
}
