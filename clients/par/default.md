
# Default server configuration
#
server {
        
        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files $uri /index.html;
        }
}

server {

        root /var/www/html;

        index index.html index.htm index.nginx-debian.html;
    server_name www.easyonwardticket.com easyonwardticket.com; # managed by Certbot

        location / {
                try_files $uri /index.html;
        }

    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/easyonwardticket.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/easyonwardticket.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
server {
    if ($host = www.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
    if ($host = easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
        listen 80 ;
        listen [::]:80 ;
    server_name www.easyonwardticket.com easyonwardticket.com;
    return 404; # managed by Certbot
}