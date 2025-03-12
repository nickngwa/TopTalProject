# Create network infrastructure
module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Create database tier
module "database" {
  source = "./modules/database"

  project_name   = var.project_name
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.private_subnet_ids
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  instance_class = var.instance_class
}

module "api_tier" {
  source = "./modules/api_tier"

  project_name  = var.project_name
  vpc_id        = module.networking.vpc_id
  subnet_ids    = module.networking.public_subnet_ids
  ami_id        = var.ami_id
  instance_type = var.api_instance_type
  key_name      = var.key_name
  api_port      = var.api_port

  # Use an empty list initially
  web_security_group_ids = []

  # Database connection info
  db_host     = module.database.db_address
  db_port     = module.database.db_port
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

# Then deploy the web tier
module "web_tier" {
  source = "./modules/web_tier"

  project_name  = var.project_name
  vpc_id        = module.networking.vpc_id
  subnet_ids    = module.networking.public_subnet_ids
  ami_id        = var.ami_id
  instance_type = var.web_instance_type
  key_name      = var.key_name
  web_port      = var.web_port

  # API connection info
  api_endpoint = module.api_tier.api_endpoint
}

# Finally, add a security group rule to allow web tier to access API tier
resource "aws_security_group_rule" "api_from_web" {
  type                     = "ingress"
  from_port                = var.api_port
  to_port                  = var.api_port
  protocol                 = "tcp"
  security_group_id        = module.api_tier.api_security_group_id
  source_security_group_id = module.web_tier.web_security_group_id

  depends_on = [module.api_tier, module.web_tier]
}