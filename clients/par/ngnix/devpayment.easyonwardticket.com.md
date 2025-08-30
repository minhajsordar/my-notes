server {
    server_name devpayment.easyonwardticket.com www.devpayment.easyonwardticket.com;
    root /var/www/devpayment.easyonwardticket.com;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/devpayment.easyonwardticket.com/fullchain.pem; # managed by >
    ssl_certificate_key /etc/letsencrypt/live/devpayment.easyonwardticket.com/privkey.pem; # managed b>
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = www.devpayment.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    if ($host = devpayment.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name devpayment.easyonwardticket.com www.devpayment.easyonwardticket.com;
    return 404; # managed by Certbot

}