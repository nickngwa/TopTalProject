# terraform.tfvars - Production Environment

# Project Settings
aws_region   = "us-east-1"
project_name = "node-3tier"

# Account Settings (sensitive - consider using AWS SSM Parameter Store instead)
# account_id         = "123456789012"  # Replace with your actual AWS account ID
# gitlab_external_id = "gitlab-external-id-123"  # Replace with your GitLab external ID

# Network Configuration
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
# EC2 Configuration
ami_id            = "ami-05b10e08d247fb927"  # Update with the latest Amazon Linux 2 AMI
key_name          = "node-3tier-key"  # Replace with your SSH key name
web_instance_type = "t3.small"  # More resources for production
api_instance_type = "t3.small"

# Application Configuration
web_port = 3000
api_port = 3000

# Database Configuration (sensitive - consider using AWS SSM Parameter Store instead)
db_name              = "ngwa-node3tier"
db_username          = "dbadmin"  # Replace with secure username
#db_password          = "YourSecurePassword123!"  
db_instance_class    = "db.t3.small"  # More resources for production
