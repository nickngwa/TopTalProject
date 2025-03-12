#Variables

variable "project_name" {
    description = "Name of the project for resource naming"
    type = string
}

variable "vpc_id" {
    description = "ID of the VPC"
    type = string
}

variable "subnet_ids" {
    description = "Subnet ids for db subnet group"
    type = list(string)
}

variable "allowed_security_group_ids" {
    description = "List of security group IDs allowed to connect to database"
    type = list(string)
    default = []
}

variable "allocated_storage" {
  description = "Allocated storage size in GB"
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "Version of PostgreSQL engine"
  type        = string
  default     = "17.4-R1"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to deploy a multi-AZ RDS instance"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}