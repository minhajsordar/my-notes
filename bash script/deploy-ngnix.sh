#!/bin/bash

# sudo ./deploy.sh example.com you@example.com 3000 production mongodb://user:pass@host:port/dbname mysecretkey
# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or uses sudo."
  exit 1
fi

# Get the domain name, email, and environment variables as arguments
DOMAIN_NAME=$1
EMAIL=$2
SERVER_PORT=$3
NODE_ENV=$4
DB_URI=$5
SECRET=$6

# Check if the required arguments are provided
if [ -z "$DOMAIN_NAME" ] || [ -z "$EMAIL" ]; then
  echo "Usage: ./deploy.sh <domain_name> <email> [SERVER_PORT] [NODE_ENV] [DB_URI] [SECRET]"
  exit 1
fi

# Prompt for environment variables if not provided
if [ -z "$SERVER_PORT" ]; then
  read -p "Enter SERVER_PORT (e.g., 3000): " SERVER_PORT
fi
if [ -z "$NODE_ENV" ]; then
  read -p "Enter NODE_ENV (e.g., production): " NODE_ENV
fi
if [ -z "$DB_URI" ]; then
  read -p "Enter DB_URI (e.g., mongodb://...): " DB_URI
fi
if [ -z "$SECRET" ]; then
  read -p "Enter SECRET (e.g., your-secret-key): " SECRET
fi

APP_DIR=~/apps/${DOMAIN_NAME}

# Step 1: Create directories for the repo and destination
mkdir -p ${APP_DIR}/repo
mkdir -p ${APP_DIR}/dest

# Step 2: Initialize bare git repo
cd ${APP_DIR}/repo
git --bare init

# Step 3: Set up the post-receive hook
cat <<EOT > hooks/post-receive
#!/bin/bash -l
echo 'post-receive: Triggered.'
cd ${APP_DIR}/dest/
echo 'post-receive: git check out...'
if ! git --git-dir=${APP_DIR}/repo/ --work-tree=${APP_DIR}/dest/ checkout main -f; then
  echo "Failed to checkout main branch."
  exit 1
fi
echo 'post-receive: npm install...'
if ! npm install; then
  echo "npm install failed."
  exit 1
fi
if ! npm run build; then
  echo "npm run build failed."
  exit 1
fi
echo 'Installation and build done.'
EOT

# Step 4: Make the post-receive hook executable
chmod ug+x hooks/post-receive

# Step 5: Create .env file with environment variables
cat <<EOT > ${APP_DIR}/dest/.env
NODE_ENV=${NODE_ENV}
DB_URI=${DB_URI}
SECRET=${SECRET}
EOT

echo ".env file created with the following content:"
echo "NODE_ENV=${NODE_ENV}"
echo "DB_URI=${DB_URI}"
echo "SECRET=${SECRET}"

# Step 6: Create the Nginx configuration file
NGINX_CONF="/etc/nginx/sites-available/${DOMAIN_NAME}"

sudo bash -c "cat > ${NGINX_CONF}" <<EOT
server {
    listen 80;
    server_name ${DOMAIN_NAME} www.${DOMAIN_NAME};

    location / {
        proxy_pass http://127.0.0.1:${SERVER_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOT

# Step 7: Enable the new site
ln -s ${NGINX_CONF} /etc/nginx/sites-enabled/

# Step 8: Test and restart Nginx
sudo nginx -t
if [ $? -eq 0 ]; then
    sudo systemctl restart nginx
    echo "Nginx restarted successfully."
else
    echo "Nginx configuration test failed. Please check your settings."
    exit 1
fi

# Step 9: Install SSL using Certbot
sudo certbot --nginx -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME} --agree-tos -m ${EMAIL} --no-eff-email --redirect
sudo certbot renew --dry-run

echo "Deployment completed for ${DOMAIN_NAME}"
