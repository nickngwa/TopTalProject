# modules/api_tier/outputs.tf

# DNS name of the load balancer for API access
output "api_endpoint" {
  description = "Endpoint of the API load balancer"
  value       = aws_lb.api.dns_name
}

# Security group ID for reference by other resources
output "api_security_group_id" {
  description = "ID of the API tier security group"
  value       = aws_security_group.api.id
}

# List of instance IDs for reference
output "instance_ids" {
  description = "IDs of the API tier instances"
  value       = aws_instance.api[*].id
}

# Load balancer ARN for reference
output "lb_arn" {
  description = "ARN of the API load balancer"
  value       = aws_lb.api.arn
}

# Target group ARN for reference
output "target_group_arn" {
  description = "ARN of the API target group"
  value       = aws_lb_target_group.api.arn
}