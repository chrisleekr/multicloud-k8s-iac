output "instance_ids" {
  description = "The IDs of the instances"
  value       = aws_instance.web[*].id
}

output "private_ips" {
  description = "The private IP addresses of the instances"
  value       = aws_instance.web[*].private_ip
}
