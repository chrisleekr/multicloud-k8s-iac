output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web.arn
}
