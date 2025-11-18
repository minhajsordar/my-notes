# install nginx

sudo apt update
sudo apt install nginx
sudo ufw allow "Nginx HTTP"
sudo systemctl status nginx

cd /etc/nginx/sites-available/
sudo nano /etc/nginx/sites-available/default
nano defaults

delete right after www

### Test config
sudo nginx -t

### Start Nginx
sudo systemctl start nginx
### Restart Nginx
sudo systemctl restart nginx

