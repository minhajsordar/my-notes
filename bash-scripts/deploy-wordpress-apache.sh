#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Get the domain name, email, and MySQL root password as arguments
DOMAIN_NAME=$1
EMAIL=$2
MYSQL_ROOT_PASSWORD=$3

# Check if the required arguments are provided
if [ -z "$DOMAIN_NAME" ] || [ -z "$EMAIL" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  echo "Usage: ./deploy-wordpress.sh <domain_name> <email> <mysql_root_password>"
  exit 1
fi

# Set the WordPress database name, user, and password
DB_NAME="wordpress_${DOMAIN_NAME//./_}"
DB_USER="wpuser_${DOMAIN_NAME//./_}"
# DB_PASSWORD="$(openssl rand -base64 12)@12pa"
# DB_PASSWORD="$(openssl rand -base64 12 | tr -d '/\\')@12pa"
DB_PASSWORD="$(openssl rand -base64 12 | sed 's/\//0/g')@12"


# Step 1: Create directories for WordPress
APP_DIR=/var/www/${DOMAIN_NAME}
mkdir -p ${APP_DIR}

# Step 2: Download WordPress
wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzf /tmp/latest.tar.gz -C ${APP_DIR} --strip-components=1
rm /tmp/latest.tar.gz

# Step 3: Set permissions for the WordPress directory
chown -R www-data:www-data ${APP_DIR}
chmod -R 755 ${APP_DIR}

# Step 4: Set up the MySQL database and user
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${DB_NAME};"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Step 5: Create the wp-config.php file
cp ${APP_DIR}/wp-config-sample.php ${APP_DIR}/wp-config.php

# Update the wp-config.php file with database details
sed -i "s/database_name_here/${DB_NAME}/" ${APP_DIR}/wp-config.php
sed -i "s/username_here/${DB_USER}/" ${APP_DIR}/wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" ${APP_DIR}/wp-config.php

# Generate WordPress salts and add them to the config
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sed -i "/AUTH_KEY/c\\${SALT}" ${APP_DIR}/wp-config.php

# Step 6: Set up the Apache virtual host configuration
APACHE_CONF="/etc/apache2/sites-available/${DOMAIN_NAME}.conf"

sudo bash -c "cat > ${APACHE_CONF}" <<EOT
<VirtualHost *:80>
    ServerAdmin ${EMAIL}
    ServerName ${DOMAIN_NAME}
    ServerAlias www.${DOMAIN_NAME}
    DocumentRoot ${APP_DIR}
    <Directory ${APP_DIR}>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

# Step 7: Enable the new site and restart Apache
sudo a2ensite ${DOMAIN_NAME}.conf
sudo systemctl reload apache2

# Step 8: Install SSL using Certbot
sudo certbot -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME} --apache --agree-tos -m ${EMAIL} --no-eff-email --redirect
sudo certbot renew --dry-run

echo "WordPress deployment completed for ${DOMAIN_NAME}"
echo "Database Name: ${DB_NAME}"
echo "Database User: ${DB_USER}"
echo "Database Password: ${DB_PASSWORD}"
