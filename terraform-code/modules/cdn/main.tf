# modules/cdn/main.tf

# CloudFront distribution for the web tier
# Serves as a CDN for static content and improves global load times
resource "aws_cloudfront_distribution" "web_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name} Web Tier CDN"
  default_root_object = "index.html"
  price_class         = var.price_class  # Controls which edge locations are used
  
  # Origin configuration - points to web ALB
  origin {
    domain_name = var.web_lb_domain_name
    origin_id   = var.web_lb_origin_id
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"  # Web ALB uses HTTP
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  # Default behavior for requests
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.web_lb_origin_id
    
    # Cache configuration
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    
    viewer_protocol_policy = "redirect-to-https"  # Force HTTPS for viewers
    min_ttl                = 0
    default_ttl            = 3600    # 1 hour default cache
    max_ttl                = 86400   # 1 day maximum cache
    compress               = true    # Enable compression
  }
  
  # Restrict to specific countries if needed
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # For specific countries: restriction_type = "whitelist", locations = ["US", "CA", "GB", "DE"]
    }
  }
  
  # SSL certificate configuration
  viewer_certificate {
    cloudfront_default_certificate = true  # Use CloudFront's default certificate
    # For custom domain: acm_certificate_arn = var.certificate_arn, ssl_support_method = "sni-only"
  }
  
  tags = {
    Name = "${var.project_name}-cdn"
  }
}