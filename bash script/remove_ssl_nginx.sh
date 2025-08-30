#!/bin/bash

# Usage: ./remove_ssl_nginx.sh domain.com

DOMAIN=$1
CONF_PATH="/etc/nginx/sites-available/$DOMAIN.conf"
ENABLED_PATH="/etc/nginx/sites-enabled/$DOMAIN.conf"

if [[ -z "$DOMAIN" ]]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

echo "=== Removing SSL certificate for $DOMAIN ==="
sudo certbot delete --cert-name "$DOMAIN"

echo "=== Removing Nginx configuration files ==="
if [[ -f "$CONF_PATH" ]]; then
  sudo rm -f "$CONF_PATH"
  echo "Removed $CONF_PATH"
fi

if [[ -f "$ENABLED_PATH" ]]; then
  sudo rm -f "$ENABLED_PATH"
  echo "Removed $ENABLED_PATH"
fi

echo "=== Cleaning broken symlinks in sites-enabled ==="
sudo find /etc/nginx/sites-enabled -xtype l -delete

echo "=== Testing Nginx configuration ==="
if ! sudo nginx -t; then
  echo "❌ Nginx config test failed after deletion. Please check manually."
  exit 1
fi

echo "✅ Reloading Nginx"
sudo systemctl reload nginx

echo "🧹 SSL certificate and Nginx conf for $DOMAIN removed successfully."
