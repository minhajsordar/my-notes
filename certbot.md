To remove an SSL certificate for a specific domain in **Nginx with Certbot**, follow these steps:

### **1. Remove the Certificate Using Certbot**
Run the following command to delete the SSL certificate:
```bash
sudo certbot delete --cert-name example.com
```
Replace `example.com` with your actual domain name.

### **2. Remove SSL Configuration from Nginx**
Open the Nginx configuration file for your domain:
```bash
sudo nano /etc/nginx/sites-available/example.com
```
Remove or update the SSL-related lines (usually `listen 443 ssl;`, `ssl_certificate`, and `ssl_certificate_key`).

Alternatively, replace the SSL-enabled server block with a simple HTTP version:
```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### **3. Restart Nginx**
After saving the changes, restart Nginx:
```bash
sudo systemctl restart nginx
```

### **4. Remove the Certificate Files Manually (Optional)**
If you want to ensure all certificate files are deleted, remove them manually:
```bash
sudo rm -rf /etc/letsencrypt/live/example.com
sudo rm -rf /etc/letsencrypt/archive/example.com
sudo rm -rf /etc/letsencrypt/renewal/example.com.conf
```

### **5. Verify the Removal**
Run the following to confirm the certificate is no longer active:
```bash
sudo certbot certificates
```
Your domain should no longer appear in the list.

Let me know if you need further help! 🚀