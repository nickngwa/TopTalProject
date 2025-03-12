# modules/web_tier/outputs.tf

# DNS name of the load balancer for web access
output "web_endpoint" {
  description = "Public endpoint of the web load balancer"
  value       = aws_lb.web.dns_name
}

# Security group ID for reference by other resources
output "web_security_group_id" {
  description = "ID of the web tier security group"
  value       = aws_security_group.web.id
}

# List of instance IDs for reference
output "instance_ids" {
  description = "IDs of the web tier instances"
  value       = aws_instance.web[*].id
}

# Load balancer ARN for reference
output "lb_arn" {
  description = "ARN of the web load balancer"
  value       = aws_lb.web.arn
}

# Target group ARN for reference
output "target_group_arn" {
  description = "ARN of the web target group"
  value       = aws_lb_target_group.web.arn
}