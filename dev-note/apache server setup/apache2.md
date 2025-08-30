# install apache2 if not installed

``` sh
sudo apt update
sudo apt install apache2
```

### details here
``` sh
https://ubuntu.com/tutorials/install-and-configure-apache#2-installing-apache
```

## create proxy
``` sh
sudo a2enmod proxy proxy_http rewrite headers expires
```

## create new file
``` sh
sudo nano /etc/apache2/sites-available/yourdomain.net.conf
```

## Server code 
here i am using 5002 for example you should use server listened port 

example virtual host code for node server or dynamic web server

``` sh
<VirtualHost *:80>
    ServerName yourdomain.net
    ServerAlias www.yourdomain.net
        ProxyRequests Off
        ProxyPreserveHost On
        ProxyVia Full
        <Proxy *>
            Require all granted
        </Proxy>
        ProxyPass / http://127.0.0.1:5002/
        ProxyPassReverse / http://127.0.0.1:5002/
</VirtualHost>
```

# Details information here
``` sh
https://httpd.apache.org/docs/2.4/vhosts/examples.html
```

### Now disable apache default site 
``` sh
sudo a2dissite 000-default
```

### Now enable apache new domain conf
``` sh
sudo a2ensite yourdomain.net.conf
sudo a2ensite mysite.net.conf
```

### Restart apache server
``` sh
sudo systemctl restart apache2
sudo systemctl reload apache2
```
