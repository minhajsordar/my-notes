```
 Empty set (0.00 sec) user not exist
```
If the MySQL user you're trying to use in WordPress (`wpuser_wpclients_begunipik_com`) doesn't exist, you'll need to create it and grant it the necessary permissions to access the database.

Here are the steps to create the user and grant permissions:

### **Step 1: Login to MySQL as Root**

Log into MySQL using the root account or another account with administrative privileges:

```bash
mysql -u root -p
```

Enter the root password when prompted.

### **Step 2: Create the MySQL User**

To create a new MySQL user, use the following command. Replace `wpuser_wpclients_begunipik_com` with the desired username and `your_database_password` with a strong password:

```sql
CREATE USER 'wpuser_wpclients_begunipik_com'@'localhost' IDENTIFIED BY 'your_database_password';
```

This command will create a new user named `wpuser_wpclients_begunipik_com` with access from `localhost`, and assign it the password you specified.

### **Step 3: Create the WordPress Database (if not already created)**

If you haven't already created the WordPress database, you can create it with the following command. Replace `your_database_name` with the actual name of your database (it should match the name in your `wp-config.php` file):

```sql
CREATE DATABASE your_database_name;
```

### **Step 4: Grant Privileges to the New User**

Now, grant the new user (`wpuser_wpclients_begunipik_com`) all privileges on the WordPress database. Replace `your_database_name` with your actual WordPress database name:

```sql
GRANT ALL PRIVILEGES ON your_database_name.* TO 'wpuser_wpclients_begunipik_com'@'localhost';
```

This command grants the user full control over the specified database.

### **Step 5: Flush Privileges**

After granting privileges, it’s essential to reload the MySQL privilege tables so that the changes take effect:

```sql
FLUSH PRIVILEGES;
```

### **Step 6: Verify User Creation**

To ensure the user has been created and has the proper permissions, you can list all users and check the user's access:

```sql
SELECT user, host FROM mysql.user WHERE user = 'wpuser_wpclients_begunipik_com';
```

If the user appears in the result, it's been successfully created.

### **Step 7: Update `wp-config.php` with the Correct Credentials**

Make sure that your `wp-config.php` file has the correct database credentials. Specifically, update it with the new database name, user, and password:

```php
define('DB_NAME', 'your_database_name');
define('DB_USER', 'wpuser_wpclients_begunipik_com');
define('DB_PASSWORD', 'your_database_password');
define('DB_HOST', 'localhost');
```

Save and exit the file.

### **Step 8: Restart Apache or PHP-FPM (if necessary)**

After making these changes, you might need to restart your web server for the changes to take effect:

For Apache (Ubuntu/Debian):

```bash
sudo systemctl restart apache2
```

For Apache (CentOS/RHEL):

```bash
sudo systemctl restart httpd
```

For Nginx:

```bash
sudo systemctl restart nginx
```

### **Step 9: Test the Connection**

Try accessing your WordPress site again. If everything was configured correctly, the "Error establishing a database connection" message should be resolved.

---

### Conclusion:

You’ve now created the MySQL user, granted it the necessary permissions, and ensured that WordPress can connect to the database. If you continue to encounter issues, double-check that the database name, user, and password in `wp-config.php` match the values in MySQL. Let me know if you need further assistance!