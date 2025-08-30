- easy onward
```
server {
    server_name payment.easyonwardticket.com www.payment.easyonwardticket.com;
    root /var/www/payment.easyonwardticket.com;

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
    ssl_certificate /etc/letsencrypt/live/payment.easyonwardticket.com/fullchain.pem; # managed by >
    ssl_certificate_key /etc/letsencrypt/live/payment.easyonwardticket.com/privkey.pem; # managed b>
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.payment.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = payment.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name payment.easyonwardticket.com www.payment.easyonwardticket.com;
    return 404; # managed by Certbot

}
```

ssadmin
```
server {
    server_name ssadmin.easyonwardticket.com www.ssadmin.easyonwardticket.com;
    root /var/www/ssadmin.easyonwardticket.com;

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
    ssl_certificate /etc/letsencrypt/live/ssadmin.easyonwardticket.com/fullchain.pem; # managed by >
    ssl_certificate_key /etc/letsencrypt/live/ssadmin.easyonwardticket.com/privkey.pem; # managed b>
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = www.ssadmin.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    if ($host = ssadmin.easyonwardticket.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name ssadmin.easyonwardticket.com www.ssadmin.easyonwardticket.com;
    return 404; # managed by Certbot

}
```

sudo ln -s /etc/nginx/sites-available/dev.easyonwardticket.com /etc/nginx/sites-enabled/dev.easyonwardticket.com