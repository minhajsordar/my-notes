### link instruction
https://www.youtube.com/watch?v=ZKaWTK91ECQ
https://stackoverflow.com/questions/4809112/hosting-two-domains-using-only-one-vps

### update ubuntu 22.04
sudo apt-get update
sudo apt-get upgrade
sudo apt install git
sudo apt-get install curl

# install apache
sudo apt install apache2

## or nginx
sudo apt install nginx
sudo ufw allow "Nginx HTTP"
sudo systemctl status nginx

# install nodejs doc
https://nodejs.org/en/download
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04

# install nodejs.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm list-remote
nvm install v14.10.0

# install denojs
curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL=/usr/local sh

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env 

### creating repo folders
mkdir -p ~/apps/expressapigen/repo
mkdir -p ~/apps/expressapigen/dest

mkdir -p ~/apps/begunipik/repo
mkdir -p ~/apps/begunipik/dest

mkdir -p ~/apps/begunipikbackend/repo
mkdir -p ~/apps/begunipikbackend/dest

mkdir -p ~/apps/mntfashion/repo
mkdir -p ~/apps/mntfashionfrontend/dest

mkdir -p ~/apps/pos.begunipik/repo
mkdir -p ~/apps/pos.begunipik/dest

### create central repo
go to folder 

cd ~/apps/expressapigen/repo
cd ~/apps/begunipik/repo
cd ~/apps/pos.begunipik/repo
cd ~/apps/linksharingapp/repo
git --bare init

### open hooks folder
nano hooks/post-receive

#!/bin/bash
echo 'post-receive: Triggered.'

# Load nvm and use correct Node version
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm use node

APP_DIR=~/apps/begunipik
DEST_DIR=$APP_DIR/dest
REPO_DIR=$APP_DIR/repo

echo "post-receive: Checking out the latest code..."
git --git-dir=$REPO_DIR --work-tree=$DEST_DIR checkout main -f

cd $DEST_DIR || exit
echo "post-receive: Installing dependencies..."
npm install

echo "post-receive: Building the Next.js app..."
npm run build

echo "post-receive: Deployment finished."

pm2 restart begunipik.com


### change permission of git post receive
- if you don't change permission it will not trigger
chmod ug+x hooks/post-receive

## create .env
cd ../dest
nano .env

## create apache proxy
sudo a2enmod proxy proxy_http rewrite headers expires

## create new file
sudo nano /etc/apache2/sites-available/expressapigen.com.conf
sudo nano /etc/apache2/sites-available/begunipik.com.conf
sudo nano /etc/apache2/sites-available/app.begunipik.com.conf
sudo nano /etc/apache2/sites-available/sharelink.begunipik.com.conf

<VirtualHost *:80>
    ServerName begunipik.com
    ServerAlias www.begunipik.com
        ProxyRequests Off
        ProxyPreserveHost On
        ProxyVia Full
        <Proxy *>
            Require all granted
        </Proxy>
        ProxyPass / http://127.0.0.1:5455/
        ProxyPassReverse / http://127.0.0.1:5455/
</VirtualHost>

<VirtualHost *:80>
    ServerName app.begunipik.com
    ServerAlias www.app.begunipik.com
        ProxyRequests Off
        ProxyPreserveHost On
        ProxyVia Full
        <Proxy *>
            Require all granted
        </Proxy>
        ProxyPass / http://127.0.0.1:5455/
        ProxyPassReverse / http://127.0.0.1:5455/
</VirtualHost>
<VirtualHost *:80>
    ServerName sharelink.begunipik.com
    ServerAlias www.sharelink.begunipik.com
        ProxyRequests Off
        ProxyPreserveHost On
        ProxyVia Full
        <Proxy *>
            Require all granted
        </Proxy>
        ProxyPass / http://127.0.0.1:5003/
        ProxyPassReverse / http://127.0.0.1:5003/
</VirtualHost>

### now disable apache default site 
sudo a2dissite 000-default
sudo a2dissite begunipik.com.conf

### now enable apache new domain conf
sudo a2dissite begunipik.com.conf 
sudo a2ensite pos.begunipik.com.conf 
sudo a2dissite api.begunipik.com.conf 
sudo a2ensite app.begunipik.com.conf 
sudo a2ensite sharelink.begunipik.com.conf 

### how to stop server
sudo systemctl stop apache2

### restart apache server
sudo systemctl restart apache2
sudo systemctl reload apache2

### add ssl certificate for apache
sudo apt install certbot python3-certbot-apache
sudo certbot -d begunipik.com -d www.begunipik.com --nginx --agree-tos -m minhajsorder8205@gmail.com --no-eff-email --redirect

### add ssl certificate for nginx
sudo apt install certbot python3-certbot-nginx
sudo certbot certonly --nginx -d softvasion.com -d www.softvasion.com
sudo certbot certonly --nginx -d softrking.com -d www.softrking.com
sudo certbot certonly --nginx -d softrking.com -d www.softrking.com --agree-tos -m minhajsorder8205@gmail.com --no-eff-email --redirect

sudo certbot certonly --nginx -d pos.softrking.com -d www.pos.softrking.com
sudo certbot certonly --nginx -d pos.softrking.com -d www.pos.softrking.com --agree-tos -m minhajsorder8205@gmail.com --no-eff-email --redirect

### rest
sudo certbot renew
sudo certbot renew --dry-run

# screen
create screen and start server or 
create forever process

# install forever

sudo npm install forever -g

forever start --uid="begunipik" --sourceDir="/root/apps/begunipik/dest/" -c "npm start" ./
forever start --uid="begunipikbackend" --sourceDir="/root/apps/begunipikbackend/dest/" backend/server.js
forever start --uid="expressapigen" --sourceDir="/root/apps/expressapigen/dest/" backend/server.js
forever start --uid="mntfashionfrontend" --sourceDir="/root/apps/mntfashionfrontend/dest/" index.js

## push repo to hostinger server

git remote add hostinger ssh://root@194.238.22.209/root/apps/begunipik/repo/
git remote add hostinger ssh://root@194.238.22.209/root/apps/pos.begunipik/repo/
git remote add hostinger ssh://root@194.238.22.209/root/apps/mntfashion/repo/
git remote add hostinger ssh://root@194.238.22.209/root/apps/linksharingapp/repo/
git remote add hostinger ssh://root@194.238.22.209/root/apps/mntfashionfrontend/repo/

ssh://root@194.238.22.209/root/apps/expressapigenfrontend/repo/

git add . && git commit -m "msdsaf" && git push hostinger main

### then finally

forever stop --uid="begunipik" --sourceDir="/root/apps/begunipik/dest/" -c "npm start" ./
forever start --uid="begunipikbackend" --sourceDir="/root/apps/begunipikbackend/dest/" backend/server.js
forever stop --uid="expressapigen" --sourceDir="/root/apps/expressapigen/dest/" backend/server.js

forever start --uid="mntfashion" --sourceDir="/root/apps/mntfashion/dest/" backend/server.js
forever start --uid="mntfashionfrontend" --sourceDir="/root/apps/mntfashionfrontend/dest/" index.js



### show list of PORTs
sudo lsof -i tcp:PORT
sudo kill -9 PID(ID)

### is port free
sudo netstat -tuln | grep :5455

### restert 
sudo reboot

### clean all process
ps aux | grep -i node


### key gen
ssh-keygen -R 192.168.3.10

curl -v http://api.begunipik.com/api/