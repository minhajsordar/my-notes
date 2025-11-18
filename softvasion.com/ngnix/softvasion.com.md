server {
    server_name softvasion.com www.softvasion.com;

    root /var/www/softvasion.com;
    index index.html index.htm;


    # HTML: cache for 1 hour
    location ~* \.(?:html|htm)$ {
        expires 1h;
        add_header Cache-Control "public, max-age=3600";
    }

    # Static assets: cache for 1 month
    location ~* \.(?:ico|css|js|gif|jpe?g|png|woff2?|eot|ttf|svg|mp4|webm|ogg)$ {
        expires 30d;
        add_header Cache-Control "public, max-age=2592000";
    }

    # Default: try to serve files
    location / {
        try_files $uri $uri/ =404;
    }

    # Deny access to hidden files
    location ~ /\. {
        deny all;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/softvasion.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/softvasion.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    # Redirect HTTP to HTTPS
    listen 80;
    server_name softvasion.com www.softvasion.com;

    location / {
        return 301 https://$host$request_uri;
    }
}
