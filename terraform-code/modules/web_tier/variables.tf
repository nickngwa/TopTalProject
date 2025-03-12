# modules/web_tier/variables.tf

# Name prefix for all resources
variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

# VPC where resources will be created
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# Subnets for load balancer and instances
variable "subnet_ids" {
  description = "List of subnet IDs for the web tier"
  type        = list(string)
}

# AMI ID for the EC2 instances
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

# Instance size (t3.micro, t3.small, etc.)
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Number of web servers to deploy
variable "instance_count" {
  description = "Number of web instances to create"
  type        = number
  default     = 2
}

# SSH key for instance access
variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

# Port for the web application
variable "web_port" {
  description = "Port on which the web application runs"
  type        = number
  default     = 3000
}

# Endpoint of the API service
variable "api_endpoint" {
  description = "Endpoint URL of the API tier"
  type        = string
}

# Deployment environment
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "production"
}

# CIDR blocks for SSH access
variable "ssh_allowed_cidrs" {
  description = "List of CIDR blocks allowed to SSH into instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}