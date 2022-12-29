output "mysql_root_password" {
  value       = random_password.mysql_root_password.result
  description = "MySQL root password"
  sensitive   = true
}

output "mysql_boilerplate_password" {
  value       = random_password.mysql_boilerplate_password.result
  description = "MySQL boilerplate password"
  sensitive   = true
}
