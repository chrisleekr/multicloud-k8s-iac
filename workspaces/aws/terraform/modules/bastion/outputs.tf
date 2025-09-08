output "instance_id" {
  description = "The ID of the bastion instance"
  value       = aws_instance.bastion.id
}

output "public_ip" {
  description = "The public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "key_name" {
  description = "The name of the SSH key pair"
  value       = aws_key_pair.bastion.key_name
}

output "private_key" {
  description = "The private SSH key (sensitive)"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}
