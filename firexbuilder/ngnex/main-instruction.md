Below is the Nginx configuration for your Express.js server running on port `4545` with the domain `begunipik.com`. This configuration assumes you have Nginx installed and properly set up on your server:

### Steps:
1. Open your Nginx configuration file for editing. You can create a new file or edit an existing one in `/etc/nginx/sites-available/`:
   ```bash
   sudo nano /etc/nginx/sites-available/begunipik.com
   ```

2. Add the following configuration:

   ```nginx
   server {
       listen 80;
       server_name begunipik.com www.begunipik.com;

       # Root directory for static files (optional)
       root /var/www/begunipik.com/html;
       index index.html index.htm;

       # Proxy requests to Express.js server
       location / {
           proxy_pass http://127.0.0.1:4545; # Forward requests to your Express.js server
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }

       # Error pages
       error_page 404 /404.html;

       # Log files
       access_log /var/log/nginx/begunipik.com.access.log;
       error_log /var/log/nginx/begunipik.com.error.log;
   }
   ```

3. Link this configuration file to the `sites-enabled` directory:
   ```bash
   sudo ln -s /etc/nginx/sites-available/begunipik.com /etc/nginx/sites-enabled/
   ```

4. Test the Nginx configuration for syntax errors:
   ```bash
   sudo nginx -t
   ```

5. Reload Nginx to apply the changes:
   ```bash
   sudo systemctl reload nginx
   ```

### Optional: Redirect `www` to non-www
If you want to redirect `www.begunipik.com` to `begunipik.com`, you can add a redirect block:

```nginx
server {
    listen 80;
    server_name www.begunipik.com;

    return 301 $scheme://begunipik.com$request_uri;
}
```

### Notes:
- Replace `/var/www/begunipik.com/html` with the actual path to your static files, if any.
- Ensure the port `4545` is open and accessible on your server.
- Use SSL/TLS for secure connections. Consider setting up Let's Encrypt for free SSL certificates.