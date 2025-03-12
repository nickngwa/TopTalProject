# modules/api_tier/main.tf

# Security group for API tier instances
# Controls inbound and outbound traffic to API EC2 instances
resource "aws_security_group" "api" {
  name        = "${var.project_name}-api-sg"
  description = "Security group for ${var.project_name} API tier"
  vpc_id      = var.vpc_id
  
  # Allow traffic on the API port from web tier or load balancer
  ingress {
    from_port       = var.api_port
    to_port         = var.api_port
    protocol        = "tcp"
    security_groups = var.web_security_group_ids # Only allow traffic from web tier
  }
  
  # Allow SSH access for administration
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-api-sg"
  }
}

# Application Load Balancer for the API tier
# Distributes traffic across multiple API instances
resource "aws_lb" "api" {
  name               = "${var.project_name}-api-lb"
  internal           = true             # Internal load balancer (not internet-facing)
  load_balancer_type = "application"    # Application Load Balancer (HTTP/HTTPS)
  security_groups    = [aws_security_group.api.id]
  subnets            = var.subnet_ids   # Deploy across multiple subnets for HA
  
  tags = {
    Name = "${var.project_name}-api-lb"
  }
}

# Target group for the API load balancer
# Defines health checks and routes traffic to instances
resource "aws_lb_target_group" "api" {
  name     = "${var.project_name}-api-tg"
  port     = var.api_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  # Health check configuration
  health_check {
    path                = "/api/status"        # Path to health check endpoint
    port                = var.api_port         # Port to check
    healthy_threshold   = 3                    # Number of consecutive successful checks
    unhealthy_threshold = 3                    # Number of consecutive failed checks
    timeout             = 5                    # Seconds to wait for a response
    interval            = 30                   # Seconds between checks
    matcher             = "200-399"            # HTTP codes considered healthy
  }
  
  tags = {
    Name = "${var.project_name}-api-tg"
  }
}

# Load balancer listener
# Listens for connections on API port and forwards to target group
resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = var.api_port
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

# EC2 instances for the API tier
# Hosts the API application
resource "aws_instance" "api" {
  count = var.instance_count
  
  ami                    = var.ami_id                      # Base OS image
  instance_type          = var.instance_type               # Size of the instance
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))  # Distribute across subnets
  vpc_security_group_ids = [aws_security_group.api.id]     # Security group rules
  key_name               = var.key_name                    # SSH key for access
  
  # Bootstrap script to set up the application
  user_data = templatefile("${path.module}/scripts/init.sh", {
    app_port = var.api_port
    db_host  = var.db_host
    db_port  = var.db_port
    db_name  = var.db_name
    db_user  = var.db_username
    db_pass  = var.db_password
    node_env = var.environment
  })
  
  tags = {
    Name = "${var.project_name}-api-${count.index + 1}"
  }
}

# Associate instances with the target group
# Enables load balancer to route traffic to instances
resource "aws_lb_target_group_attachment" "api" {
  count = var.instance_count
  
  target_group_arn = aws_lb_target_group.api.arn
  target_id        = aws_instance.api[count.index].id
  port             = var.api_port
}