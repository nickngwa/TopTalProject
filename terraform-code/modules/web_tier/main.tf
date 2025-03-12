# modules/web_tier/main.tf

# Security group for web tier instances
# Controls inbound and outbound traffic to EC2 instances
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for ${var.project_name} web tier"
  vpc_id      = var.vpc_id
  
  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow traffic on the application port
  ingress {
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "${var.project_name}-web-sg"
  }
}

# Application Load Balancer for the web tier
# Distributes traffic across multiple web instances
resource "aws_lb" "web" {
  name               = "${var.project_name}-web-lb"
  internal           = false            # External-facing load balancer
  load_balancer_type = "application"    # Application Load Balancer (HTTP/HTTPS)
  security_groups    = [aws_security_group.web.id]
  subnets            = var.subnet_ids   # Deploy across multiple subnets for HA
  
  tags = {
    Name = "${var.project_name}-web-lb"
  }
}

# Target group for the load balancer
# Defines health checks and routes traffic to instances
resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-web-tg"
  port     = var.web_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  # Health check configuration
  health_check {
    path                = "/"                # Path to check
    port                = var.web_port       # Port to check
    healthy_threshold   = 3                  # Number of consecutive successful checks
    unhealthy_threshold = 3                  # Number of consecutive failed checks
    timeout             = 5                  # Seconds to wait for a response
    interval            = 30                 # Seconds between checks
    matcher             = "200-399"          # HTTP codes considered healthy
  }
  
  tags = {
    Name = "${var.project_name}-web-tg"
  }
}

# Load balancer listener
# Listens for connections on port 80 and forwards to target group
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# EC2 instances for the web tier
# Hosts the web application
resource "aws_instance" "web" {
  count = var.instance_count
  
  ami                    = var.ami_id                      # Base OS image
  instance_type          = var.instance_type               # Size of the instance
  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))  # Distribute across subnets
  vpc_security_group_ids = [aws_security_group.web.id]     # Security group rules
  key_name               = var.key_name                    # SSH key for access
  
  # Bootstrap script to set up the application
  user_data = templatefile("${path.module}/scripts/init.sh", {
    app_port = var.web_port
    api_endpoint = var.api_endpoint
    node_env = var.environment
  })
  
  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}

# Associate instances with the target group
# Enables load balancer to route traffic to instances
resource "aws_lb_target_group_attachment" "web" {
  count = var.instance_count
  
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = var.web_port
}