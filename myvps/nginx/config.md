Here's the equivalent Nginx configuration for your provided Apache setup:

### Nginx Configuration:
```nginx
server {
    # Listen on port 80 for HTTP
    listen 80;
    server_name begunipik.com www.begunipik.com;

    # Redirect all HTTP traffic to HTTPS
    return 301 https://$host$request_uri;
}

server {
    # Listen on port 443 for HTTPS
    listen 443 ssl;
    server_name begunipik.com www.begunipik.com;

    # SSL certificate and key (replace with actual paths)
    ssl_certificate /path/to/ssl/certificate.crt;
    ssl_certificate_key /path/to/ssl/certificate.key;

    # Proxy settings
    location / {
        proxy_pass http://127.0.0.1:5455; # Forward requests to your app
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Security headers (optional)
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";
}
```

### Explanation:
1. **Port 80 to 443 Redirect**:
   - The first `server` block listens on port 80 and redirects all traffic to HTTPS using a `301 Permanent Redirect`.

2. **SSL Configuration**:
   - Replace `/path/to/ssl/certificate.crt` and `/path/to/ssl/certificate.key` with the paths to your SSL certificate files.

3. **Proxying to Express.js**:
   - The `location /` block proxies all incoming traffic to `http://127.0.0.1:5455`.

4. **Security Headers**:
   - Optional headers are added for better security.

### Steps to Implement:
1. Save this configuration in `/etc/nginx/sites-available/begunipik.com`.
2. Link it to `sites-enabled`:
   ```bash
   sudo ln -s /etc/nginx/sites-available/pos.begunipik.com.conf /etc/nginx/sites-enabled/
   ```
3. Test the configuration:
   ```bash
   sudo nginx -t
   ```
4. Reload Nginx:
   ```bash
   sudo systemctl reload nginx
   ```

### Notes:
- Ensure SSL certificates are in place before reloading Nginx. You can use **Let's Encrypt** to get free certificates (`certbot` is a popular tool for this).
- If SSL is not yet set up, comment out the `ssl_certificate` and `ssl_certificate_key` lines and focus on setting up the HTTP redirect.