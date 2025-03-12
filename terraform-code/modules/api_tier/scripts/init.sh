# modules/api_tier/scripts/init.sh

#!/bin/bash
set -e

# Update system packages to latest versions
sudo yum update -y

# Install Node.js repository and Node.js
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
sudo yum install -y nodejs git

# Create application directory and clone the repository
sudo mkdir -p /opt/api-app
cd /opt/api-app
sudo git clone https://github.com/nickngwa/TopTalProject.git .
cd api

# Install Node.js dependencies
sudo npm install

# Create environment variables file for the application
cat > .env <<EOF
PORT=${app_port}
DB=${db_name}
DBUSER=${db_user}
DBPASS=${db_pass}
DBHOST=${db_host}
DBPORT=${db_port}
NODE_ENV=${node_env}
EOF

# Create systemd service file for automatic startup and management
cat > /etc/systemd/system/api-app.service <<EOF
[Unit]
Description=Node.js API Application
After=network.target

[Service]
Environment=PORT=${app_port}
Environment=DB=${db_name}
Environment=DBUSER=${db_user}
Environment=DBPASS=${db_pass}
Environment=DBHOST=${db_host}
Environment=DBPORT=${db_port}
Environment=NODE_ENV=${node_env}
Type=simple
User=ec2-user
WorkingDirectory=/opt/api-app/api
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl daemon-reload
systemctl enable api-app
systemctl start api-app