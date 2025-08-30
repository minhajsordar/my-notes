server {
    server_name easyonwardticket.com www.easyonwardticket.com;
    root /var/www/html;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
        add_header Cache-Control no-store;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/easyonwardticket.com/fullchain.pem; # managed by >
    ssl_certificate_key /etc/letsencrypt/live/easyonwardticket.com/privkey.pem; # managed b>
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

    listen 80;
    server_name easyonwardticket.com www.easyonwardticket.com;
    return 404; # managed by Certbot

}