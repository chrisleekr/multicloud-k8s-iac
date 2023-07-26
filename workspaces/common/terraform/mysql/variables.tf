variable "server_instances" {
  description = "Number of MySQL service instances"
  type        = number
  default     = 2
}

variable "router_instances" {
  description = "Number of MySQL router instances"
  type        = number
  default     = 2
}

variable "mysql_resources_requests_memory" {
  description = "MySQL resources requests memory"
  type        = string
  default     = "512Mi"
}

variable "mysql_resources_requests_cpu" {
  description = "MySQL resources requests CPU"
  type        = string
  default     = "500m"
}

variable "mysql_resources_limits_memory" {
  description = "MySQL resources limits memory"
  type        = string
  default     = "1Gi"
}

variable "mysql_resources_limits_cpu" {
  description = "MySQL resources limits CPU"
  type        = string
  default     = "1"
}
