# modules/web_tier/scripts/init.sh

#!/bin/bash
set -e

# Update system packages to latest versions
sudo yum update -y

# Install Node.js repository and Node.js
curl -sL https://rpm.nodesource.com/setup_20.x | bash -
sudo yum install -y nodejs git

# Create application directory and clone the repository
sudo mkdir -p /opt/web-app
cd /opt/web-app
sudo git clone https://github.com/nickngwa/TopTalProject.git .
cd web

# Install Node.js dependencies
npm install

# Create environment variables file for the application
cat > .env <<EOF
PORT=${app_port}
API_HOST=${api_endpoint}
NODE_ENV=${node_env}
EOF

# Create systemd service file for automatic startup and management
cat > /etc/systemd/system/web-app.service <<EOF
[Unit]
Description=Node.js Web Application
After=network.target

[Service]
Environment=PORT=${app_port}
Environment=API_HOST=${api_endpoint}
Environment=NODE_ENV=${node_env}
Type=simple
User=ec2-user
WorkingDirectory=/opt/web-app/web
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl daemon-reload
systemctl enable web-app
systemctl start web-app