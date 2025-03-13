output "db_endpoint" {
  description = "Database endpoint"
  value       = module.database.db_endpoint
}

output "web_endpoint" {
  description = "Web tier load balancer endpoint"
  value       = module.web_tier.web_endpoint
}

output "api_endpoint" {
  description = "API tier load balancer endpoint"
  value       = module.api_tier.api_endpoint
}


output "cdn_domain_name" {
  description = "CloudFront CDN domain name"
  value       = module.cdn.cloudfront_domain_name
}