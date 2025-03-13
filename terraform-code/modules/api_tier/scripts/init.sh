# modules/api_tier/scripts/init.sh

#!/bin/bash
set -e

# Update system packages to latest versions
sudo yum update -y

# Install Node.js repository and Node.js
curl -sL https://rpm.nodesource.com/setup_20.x | bash -
sudo yum install -y nodejs git

# Create application directory and clone the repository
sudo mkdir -p /opt/api-app
cd /opt/api-app
sudo git clone https://github.com/nickngwa/TopTalProject.git .
cd api

# Install Node.js dependencies
sudo npm install

# Create environment variables file for the application
sudo bash -c 'echo -e "PORT=${app_port}\nDB=${db_name}\nDBUSER=${db_user}\nDBPASS=${db_pass}\nDBHOST=${db_host}\nDBPORT=${db_port}\nNODE_ENV=${node_env}" > .env'

# Create systemd service file for automatic startup and management
sudo bash -c 'echo -e "[Unit]\nDescription=Node.js API Application\nAfter=network.target\n\n[Service]\nEnvironment=PORT=${app_port}\nEnvironment=DB=${db_name}\nEnvironment=DBUSER=${db_user}\nEnvironment=DBPASS=${db_pass}\nEnvironment=DBHOST=${db_host}\nEnvironment=DBPORT=${db_port}\nEnvironment=NODE_ENV=${node_env}\nType=simple\nUser=ec2-user\nWorkingDirectory=/opt/api-app/api\nExecStart=/usr/bin/npm start\nRestart=always\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/api-app.service'

# Enable and start the service
systemctl daemon-reload
systemctl enable api-app
systemctl start api-app