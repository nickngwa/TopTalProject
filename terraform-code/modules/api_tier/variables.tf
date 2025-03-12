# modules/api_tier/variables.tf

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
  description = "List of subnet IDs for the API tier"
  type        = list(string)
}

# Security group IDs that can access the API
variable "web_security_group_ids" {
  description = "List of security group IDs allowed to access the API"
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

# Number of API servers to deploy
variable "instance_count" {
  description = "Number of API instances to create"
  type        = number
  default     = 2
}

# SSH key for instance access
variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

# Port for the API application
variable "api_port" {
  description = "Port on which the API application runs"
  type        = number
  default     = 3000
}

# Database connection parameters
variable "db_host" {
  description = "Database host address"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
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