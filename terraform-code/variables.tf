variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  default     = "node-3tier"
}

# Network variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# Compute variables
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-05b10e08d247fb927" # Amazon Linux 2
}

variable "web_instance_type" {
  description = "Web tier instance type"
  default     = "t3.micro"
}

variable "api_instance_type" {
  description = "API tier instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  default     = "node-3tier-key"
}

# Application variables
variable "web_port" {
  description = "Web application port"
  default     = 3000
}

#variable "web_security_group_ids" {
 # description = "List of security group IDs allowed to access the API"
  #type        = list(string)
#}

variable "api_port" {
  description = "API application port"
  default     = 3000
}

# Database variables
variable "db_name" {
  description = "Database name"
  default     = "node3tier"
}

variable "db_username" {
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class controlling which edge locations to use"
  type        = string
  default     = "PriceClass_100" # Use only US, Canada, Europe edge locations
}