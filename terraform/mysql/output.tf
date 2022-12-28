output "mysql_root_password" {
  value = random_password.mysql_root_password.result
}

output "mysql_boilerplate_password" {
  value = random_password.mysql_boilerplate_password.result
}
