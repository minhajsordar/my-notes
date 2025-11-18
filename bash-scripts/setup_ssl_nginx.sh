#!/bin/bash

# Usage: ./setup_ssl_nginx.sh domain.com email@example.com 5004

DOMAIN=$1
EMAIL=$2
PORT=$3
CONF_PATH="/etc/nginx/sites-available/$DOMAIN.conf"
ENABLED_PATH="/etc/nginx/sites-enabled/$DOMAIN.conf"

if [[ -z "$DOMAIN" || -z "$EMAIL" || -z "$PORT" ]]; then
  echo "Usage: $0 domain.com email@example.com 5004"
  exit 1
fi

echo "=== Requesting SSL certificate for $DOMAIN ==="
sudo certbot certonly --nginx -d "$DOMAIN" -d "www.$DOMAIN" --agree-tos -m "$EMAIL" --no-eff-email --non-interactive

if [[ $? -ne 0 ]]; then
  echo "❌ SSL certificate request failed."
  exit 1
fi

echo "=== Generating Nginx configuration ==="
sudo tee "$CONF_PATH" > /dev/null <<EOF
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    return 301 https://\$host\$request_uri;
}

# HTTPS configuration
server {
    listen 443 ssl;
    server_name $DOMAIN www.$DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";
}
EOF

echo "=== Enabling Nginx site ==="
sudo ln -sf "$CONF_PATH" "$ENABLED_PATH"

echo "=== Testing Nginx configuration ==="
if ! sudo nginx -t; then
  echo "❌ Nginx config test failed. Removing conf."
  sudo rm -f "$CONF_PATH" "$ENABLED_PATH"
  exit 1
fi

echo "✅ Reloading Nginx"
sudo systemctl reload nginx

echo "🎉 Setup complete for $DOMAIN"
