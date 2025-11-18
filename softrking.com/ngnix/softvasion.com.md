server {
    server_name softrking.com www.softrking.com;

    root /var/www/html;
    index index.html index.htm;

    # Serve static files
    location / {
        try_files $uri $uri/ =404;
        add_header Cache-Control no-store;
    }

    # Deny access to hidden files like .htaccess
    location ~ /\. {
        deny all;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/softrking.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/softrking.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    # Redirect HTTP to HTTPS
    listen 80;
    server_name softrking.com www.softrking.com;

    location / {
        return 301 https://$host$request_uri;
    }
}
