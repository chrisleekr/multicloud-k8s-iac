variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "aws_account_id" {
  description = "AWS Account ID where resources will be created"
  type        = string
  default     = "120569602166"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# 2^8 - 2 = 254 IP addresses
variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet in AZ a"
  type        = string
  default     = "10.0.10.0/24"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet in AZ b"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet in AZ a"
  type        = string
  default     = "10.0.20.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet in AZ b"
  type        = string
  default     = "10.0.21.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  # Amazon Linux 2023 AMI 2023.6.20250115.0 x86_64 HVM kernel-6.1
  default = "ami-0d11f9bfe33cfbe8b"
}

variable "allowed_ssh_bastion_cidr" {
  description = "CIDR block allowed to connect to bastion host via SSH - must be a CIDR block. i.e. 175.37.162.0/24"
  type        = string
  default     = "175.37.162.0/24"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Team      = "engineering"
    Terraform = "true"
    Owner     = "chrisleekr"
  }
}
