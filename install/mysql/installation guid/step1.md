To install MySQL on your server, you can follow these steps depending on the Linux distribution you're using (e.g., Ubuntu, Debian, or CentOS). I'll provide instructions for both Ubuntu/Debian and CentOS systems, as they are the most common.

### **For Ubuntu/Debian-based Systems:**

1. **Update the package list:**

   ```bash
   sudo apt update
   ```

2. **Install MySQL Server:**

   ```bash
   sudo apt install mysql-server -y
   ```

3. **Secure the MySQL installation:**

   After installing, it's a good idea to run the MySQL security script, which helps you set a root password, remove test databases, and more.

   ```bash
   sudo mysql_secure_installation
   ```

   During this process:
   - You will be asked to configure the `VALIDATE PASSWORD PLUGIN`. You can choose the level of password validation (low, medium, strong).
   - Set a strong root password when prompted.
   - You'll also have the option to remove test databases and anonymous users, disable remote root login, and reload privilege tables. It's recommended to accept all these changes for a secure setup.

4. **Check MySQL Service Status:**

   After installation, the MySQL service should start automatically. You can check its status with:

   ```bash
   sudo systemctl status mysql
   ```

   If it’s not running, you can start it manually:

   ```bash
   sudo systemctl start mysql
   ```

5. **Login to MySQL as Root:**

   You can log into the MySQL shell as the `root` user using the following command:

   ```bash
   sudo mysql -u root -p
   ```

   Enter the password you set during the `mysql_secure_installation` process.

6. **Create a Database and User (Optional):**

   After logging into MySQL, you can create a database and a user with specific privileges. For example:

   ```sql
   CREATE DATABASE my_database;
   CREATE USER 'my_user'@'localhost' IDENTIFIED BY 'my_password';
   GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   CREATE DATABASE totocompanybd;
   CREATE USER 'totocompanybd'@'localhost' IDENTIFIED BY 'totocompanybd';
   GRANT ALL PRIVILEGES ON my_database.* TO 'totocompanybd'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   ```
---

### **For CentOS/RHEL-based Systems:**

1. **Update the package list:**

   ```bash
   sudo yum update
   ```

2. **Install the MySQL repository:**

   CentOS 7 and later do not come with MySQL by default. You will need to add the MySQL Yum repository first:

   ```bash
   sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
   ```

3. **Install MySQL Server:**

   After adding the repository, you can install MySQL:

   ```bash
   sudo yum install mysql-server -y
   ```

4. **Start and Enable MySQL Service:**

   Start the MySQL service and enable it to run at boot:

   ```bash
   sudo systemctl start mysqld
   sudo systemctl enable mysqld
   ```

5. **Retrieve the Temporary Root Password:**

   After installation, MySQL generates a temporary password for the root user. You can find it by checking the logs:

   ```bash
   sudo grep 'temporary password' /var/log/mysqld.log
   ```

   You'll see something like this in the logs:
   ```
   A temporary password is generated for root@localhost: aH7b$Xsw9A1z
   ```

6. **Secure the MySQL Installation:**

   Run the security script to secure the MySQL installation and set a new root password:

   ```bash
   sudo mysql_secure_installation
   ```

   - Use the temporary password retrieved in the previous step when prompted.
   - Set a new password and follow the prompts to remove test databases, disable remote root login, etc.

7. **Login to MySQL as Root:**

   Log into the MySQL shell using the new root password:

   ```bash
   mysql -u root -p
   ```

8. **Create a Database and User (Optional):**

   Inside the MySQL shell, you can create a new database and user as shown:

   ```sql
   CREATE DATABASE my_database;
   CREATE USER 'my_user'@'localhost' IDENTIFIED BY 'my_password';
   GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   ```

---

### **Verify MySQL Installation:**

After installing MySQL, you can verify the version with:

```bash
mysql --version
```

This should output the installed MySQL version number.

### **Common MySQL Commands:**

- **To stop MySQL service:**

  ```bash
  sudo systemctl stop mysql  # For Ubuntu/Debian
  sudo systemctl stop mysqld # For CentOS/RHEL
  ```

- **To restart MySQL service:**

  ```bash
  sudo systemctl restart mysql  # For Ubuntu/Debian
  sudo systemctl restart mysqld # For CentOS/RHEL
  ```

- **To enable MySQL to start at boot:**

  ```bash
  sudo systemctl enable mysql  # For Ubuntu/Debian
  sudo systemctl enable mysqld # For CentOS/RHEL
  ```

Once installed, you are ready to configure your database for use with applications like WordPress or others.