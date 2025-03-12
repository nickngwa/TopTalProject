# modules/cdn/variables.tf

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "web_lb_domain_name" {
  description = "Domain name of the web tier load balancer"
  type        = string
}

variable "web_lb_origin_id" {
  description = "Origin ID for the web tier load balancer"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class controlling edge locations"
  type        = string
  default     = "PriceClass_100"  # Use only US, Canada, Europe edge locations
  # Options: PriceClass_All (all locations), PriceClass_200 (US, Canada, Europe, Asia, Middle East, Africa)
}