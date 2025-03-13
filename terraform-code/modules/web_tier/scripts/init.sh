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
sudo npm install

# Create environment variables file for the application
sudo bash -c 'echo -e "PORT=3000\nAPI_HOST=http://internal-node-3tier-api-lb-760255416.us-east-1.elb.amazonaws.com:3000\nNODE_ENV=production" > /opt/web-app/web/.env'

# Create systemd service file for automatic startup and management
sudo bash -c 'echo -e "[Unit]\nDescription=Node.js Web Application\nAfter=network.target\n\n[Service]\nEnvironment=PORT=3000\nEnvironment=API_HOST=http://internal-node-3tier-api-lb-760255416.us-east-1.elb.amazonaws.com:3000\nEnvironment=NODE_ENV=production\nType=simple\nUser=ec2-user\nWorkingDirectory=/opt/web-app/web\nExecStart=/usr/bin/npm start\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/web-app.service'

# Enable and start the service
systemctl daemon-reload
systemctl enable web-app
systemctl start web-app