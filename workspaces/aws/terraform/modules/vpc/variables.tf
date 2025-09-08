variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet in AZ a"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet in AZ b"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet in AZ a"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet in AZ b"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "allowed_ssh_bastion_cidr" {
  description = "CIDR block allowed to connect to bastion host via SSH"
  type        = string
}
