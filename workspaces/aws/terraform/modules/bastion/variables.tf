variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where bastion host will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for bastion host"
  type        = list(string)
}

variable "instance_name" {
  description = "Name tag for the bastion host"
  type        = string
}
