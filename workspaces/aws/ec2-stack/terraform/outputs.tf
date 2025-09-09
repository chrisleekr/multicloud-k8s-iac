output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "web_server_private_ips" {
  description = "Private IPs of the web server instances"
  value       = module.ec2.private_ips
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "bastion_instance_id" {
  description = "ID of the bastion instance"
  value       = module.bastion.instance_id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion instance"
  value       = module.bastion.public_ip
}
