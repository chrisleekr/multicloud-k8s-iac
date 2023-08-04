variable "protocol" {
  description = "HTTP protocol"
  type        = string
}

variable "domain" {
  description = "Domain Name"
  type        = string
}

variable "certificate_enabled" {
  description = "Certificate enabled"
  type        = bool
  default     = false
}

variable "certificate_issuer" {
  description = "Certificate issuer"
  type        = string
  default     = "letsencrypt"
}


variable "load_balancer_ip_address" {
  description = "Load Balancer IP Address"
  type        = string
}
