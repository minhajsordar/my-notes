mkdir -p ~/apps/linksharingapp/repo
mkdir -p ~/apps/linksharingapp/dest

cd ~/apps/linksharingapp/repo
git --bare init

nano hooks/post-receive
<!-- past this command in post-receive -->
#!/bin/bash -l
echo 'post-receive: Triggered.'
cd ~/apps/linksharingapp/dest/
echo 'post-receive: git check out...'
git --git-dir=/root/apps/linksharingapp/repo/ --work-tree=/root/apps/linksharingapp/dest/ checkout main -f
echo 'post-receive: npm install...'
npm install
npm run build
echo 'installation and build done'

<!-- save the file with ctrl + x and then y exit -->

chmod ug+x hooks/post-receive

cd ../dest
nano .env


sudo a2enmod proxy proxy_http rewrite headers expires

sudo nano /etc/apache2/sites-available/linksharingapp.com.conf


<VirtualHost *:80>
    ServerName linksharingapp.net
    ServerAlias www.linksharingapp.net
        ProxyRequests Off
        ProxyPreserveHost On
        ProxyVia Full
        <Proxy *>
            Require all granted
        </Proxy>
        ProxyPass / http://127.0.0.1:5002/
        ProxyPassReverse / http://127.0.0.1:5002/
</VirtualHost>

sudo a2ensite linksharingapp.com.conf 

sudo systemctl restart apache2
sudo systemctl reload apache2

sudo certbot -d linksharingapp.com -d www.linksharingapp.com --apache --agree-tos -m example@gmail.com --no-eff-email --redirect
sudo certbot renew --dry-run