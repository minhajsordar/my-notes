# install ngnex

sudo apt update
sudo apt install nginx
sudo ufw allow "Nginx HTTP"
sudo systemctl status nginx

cd /etc/nginx/sites-available/
sudo nano /etc/nginx/sites-available/default
nano defaults

delete right after www

sudo nginx -t

sudo systemctl start nginx
sudo systemctl restart nginx

