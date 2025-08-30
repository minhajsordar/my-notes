```
Your PHP installation appears to be missing the MySQL extension which is required by WordPress.

Please check that the mysqli PHP extension is installed and enabled.
```

The error message you're seeing indicates that WordPress requires the MySQLi extension to interact with the MySQL database, but it’s either not installed or not enabled on your server.

To resolve this issue, you need to ensure that the `mysqli` extension is installed and enabled in PHP. Follow the steps below to install and enable the MySQLi extension for PHP on your system:

### **For Ubuntu/Debian-based Systems:**

1. **Update your package list:**

   ```bash
   sudo apt update
   ```

2. **Install the MySQLi PHP extension:**

   You can install the MySQLi extension using the following command:

   ```bash
   sudo apt install php-mysqli -y
   ```

   This will install the `mysqli` extension and all necessary dependencies.

3. **Restart Apache:**

   After installing the extension, you need to restart Apache for the changes to take effect:

   ```bash
   sudo systemctl restart apache2
   ```

4. **Verify that the MySQLi extension is installed:**

   You can check if the `mysqli` extension is enabled by running the following command:

   ```bash
   php -m | grep mysqli
   ```

   If `mysqli` is installed and enabled, this command will output `mysqli`.

---

### **For CentOS/RHEL-based Systems:**

1. **Update your package list:**

   ```bash
   sudo yum update
   ```

2. **Install the MySQLi PHP extension:**

   Install the MySQLi extension for PHP using the following command:

   ```bash
   sudo yum install php-mysqli -y
   ```

   If you're using PHP 7 or higher, `php-mysqlnd` (the MySQL Native Driver) package may be installed, which also includes the MySQLi extension. To ensure everything is installed, use:

   ```bash
   sudo yum install php-mysqlnd
   ```

3. **Restart Apache or PHP-FPM:**

   If you are using Apache, restart it:

   ```bash
   sudo systemctl restart httpd
   ```

   If you are using Nginx with PHP-FPM, restart PHP-FPM:

   ```bash
   sudo systemctl restart php-fpm
   ```

4. **Verify that the MySQLi extension is installed:**

   You can check if the `mysqli` extension is enabled by running:

   ```bash
   php -m | grep mysqli
   ```

   If the extension is installed, it should return `mysqli`.

---

### **Check PHP Configuration:**

If the above steps don't work, or if the MySQLi extension is installed but not enabled, you may need to check the `php.ini` file to ensure that the `mysqli` extension is not commented out.

1. **Find the location of your `php.ini` file:**

   Run the following command to find the `php.ini` file location:

   ```bash
   php --ini
   ```

2. **Edit the `php.ini` file:**

   Open the `php.ini` file in a text editor (replace the path with the actual path you found above):

   ```bash
   sudo nano /etc/php/7.4/apache2/php.ini  # for Ubuntu (adjust PHP version accordingly)
   sudo nano /etc/php.ini  # for CentOS
   ```

3. **Uncomment the MySQLi extension:**

   Look for the line that loads the MySQLi extension (it might look like `;extension=mysqli.so`). Uncomment it by removing the semicolon (`;`), so it looks like this:

   ```ini
   extension=mysqli.so
   ```

4. **Restart Apache or PHP-FPM:**

   After making changes to the `php.ini` file, restart Apache or PHP-FPM again for the changes to take effect:

   ```bash
   sudo systemctl restart apache2  # For Ubuntu/Debian
   sudo systemctl restart httpd    # For CentOS
   sudo systemctl restart php-fpm  # For PHP-FPM with Nginx
   ```

---

### **Recheck WordPress Installation:**

Now, reload your WordPress site. The error about the missing MySQL extension should be resolved.

You can also confirm that the `mysqli` extension is active by viewing the PHP info page you created earlier (`info.php`) at `http://your_server_ip/info.php` and searching for `mysqli` in the output.