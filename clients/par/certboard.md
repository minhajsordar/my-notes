
sudo certbot -d devssadmin.easyonwardticket.com -d www.devssadmin.easyonwardticket.com --nginx --agree-tos -m ptuvang@gmail.com --no-eff-email --redirect

sudo certbot -d devpayment.easyonwardticket.com -d www.devpayment.easyonwardticket.com --nginx --agree-tos -m ptuvang@gmail.com --no-eff-email --redirect

sudo certbot -d dev.easyonwardticket.com -d www.dev.easyonwardticket.com --nginx --agree-tos -m ptuvang@gmail.com --no-eff-email --redirect
sudo certbot --nginx -d dev.easyonwardticket.com -d www.dev.easyonwardticket.com
sudo certbot renew
sudo certbot renew --dry-run


sudo ln -s /etc/nginx/sites-available/dev.easyonwardticket.com /etc/nginx/sites-enabled/dev.easyonwardticket.com