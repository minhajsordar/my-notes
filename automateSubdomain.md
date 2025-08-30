To automatically obtain and renew SSL certificates for all subdomains using Let's Encrypt, you can set up a wildcard SSL certificate. A wildcard SSL certificate secures your main domain and all its subdomains. You can automate the process using Certbot with DNS-based authentication (because Let's Encrypt requires DNS validation for wildcard certificates). Here's how you can automate this process:

### Steps to Get a Wildcard SSL Certificate with Certbot

1. **Install Certbot and the DNS plugin for your DNS provider**:
   Certbot supports multiple DNS providers through plugins, such as Cloudflare, DigitalOcean, etc. If you're using a specific DNS provider, you'll need to install the appropriate Certbot plugin.

   For example, to use Cloudflare for DNS validation, you would install the `python3-certbot-dns-cloudflare` plugin.

   On Ubuntu/Debian, you can install Certbot and the DNS plugin like this:
   ```bash
   sudo apt update
   sudo apt install certbot python3-certbot-dns-cloudflare
   ```

2. **Configure DNS API credentials**:
   You'll need API credentials from your DNS provider to allow Certbot to update DNS records for validation.

   For example, for Cloudflare:
   - Get your Cloudflare Global API Key from your Cloudflare account.
   - Create a file `~/.secrets/cloudflare.ini` with the following content:
     ```
     dns_cloudflare_email = your-cloudflare-email@example.com
     dns_cloudflare_api_key = your-global-api-key
     ```
   - Set permissions to keep the file secure:
     ```bash
     chmod 600 ~/.secrets/cloudflare.ini
     ```

3. **Run Certbot to Obtain a Wildcard SSL Certificate**:
   You can now use Certbot to request a wildcard certificate for your domain. Replace `example.com` with your actual domain and adjust the path to your `.ini` file for your DNS plugin.

   ```bash
   sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secrets/cloudflare.ini -d "*.example.com" -d example.com --agree-tos --email your-email@example.com --no-eff-email
   ```

   This command requests a wildcard certificate for `*.example.com` and `example.com`. Certbot will automatically create and delete the necessary DNS TXT records for validation.

4. **Automating Renewal**:
   Certbot automatically sets up a cron job to renew certificates 30 days before they expire, but to make sure it works with wildcard certificates (which need DNS validation), add the following to your crontab (run `crontab -e` to edit it):

   ```bash
   0 3 * * * certbot renew --dns-cloudflare --dns-cloudflare-credentials ~/.secrets/cloudflare.ini --quiet
   ```

   This runs the Certbot renewal process every day at 3 AM.

### Example of the Complete Automation Flow

Let’s say you want to automate the deployment of an SSL certificate for all subdomains (including new ones) of `example.com`. Here’s the breakdown:

1. **DNS Provider Setup**: Ensure your domain's DNS provider allows API access for adding TXT records (necessary for Let's Encrypt DNS challenge).

2. **Certbot Command**:
   - Install Certbot and the DNS plugin for your provider.
   - Configure your DNS API credentials.
   - Run Certbot with the `certonly` command to obtain the wildcard certificate.

   Example for Cloudflare:
   ```bash
   sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials ~/.secrets/cloudflare.ini -d "*.example.com" -d example.com --agree-tos --email admin@example.com --no-eff-email
   ```

3. **Renewal Automation**:
   Certbot will automatically renew certificates before expiration. However, for DNS-based validation (wildcard certificates), you need to ensure the plugin credentials are accessible.

   Set up a cron job for automated renewal:
   ```bash
   crontab -e
   ```
   Add the following entry:
   ```bash
   0 3 * * * certbot renew --dns-cloudflare --dns-cloudflare-credentials ~/.secrets/cloudflare.ini --quiet
   ```

4. **Updating Apache or Nginx Configuration**:
   Ensure that your web server (Apache or Nginx) is set to use the wildcard SSL certificate. The certificates are typically stored in `/etc/letsencrypt/live/example.com/`. Update your web server's configuration to point to the correct certificate files:
   
   For Apache, in the virtual host configuration, add:
   ```apache
   <VirtualHost *:443>
       ServerName example.com
       ServerAlias *.example.com
       SSLEngine on
       SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
       SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem
   </VirtualHost>
   ```

   For Nginx, inside your `server` block, add:
   ```nginx
   server {
       listen 443 ssl;
       server_name example.com *.example.com;
       
       ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
   }
   ```

5. **Restart the Web Server**:
   After the certificate is obtained and configured, restart your web server to apply the changes:
   ```bash
   sudo systemctl restart apache2  # for Apache
   sudo systemctl restart nginx    # for Nginx
   ```

### Summary

- **Certbot** is used to request and manage SSL certificates.
- **DNS API credentials** are required to automate the DNS validation for a wildcard certificate.
- **Automation** is achieved by setting up cron jobs for both obtaining the certificate and renewing it.
- **Apache/Nginx** configurations should be updated to use the wildcard certificate.

This approach will automatically secure your main domain and all subdomains with SSL, ensuring new subdomains are also covered without requiring additional certificates.