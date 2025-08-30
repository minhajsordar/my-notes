To completely uninstall MongoDB and remove all related files from your system, follow these steps:

### 1. **Stop MongoDB Service**
   Stop the MongoDB service if it is running:
   ```bash
   sudo systemctl stop mongod
   ```

### 2. **Remove MongoDB Packages**
   Uninstall MongoDB packages using `apt`:
   ```bash
   sudo apt-get purge mongodb-org*
   ```

### 3. **Remove Data Directories**
   MongoDB stores data in the `/var/lib/mongodb` directory by default and logs in the `/var/log/mongodb` directory. Delete these directories:
   ```bash
   sudo rm -rf /var/lib/mongodb
   sudo rm -rf /var/log/mongodb
   ```

### 4. **Remove MongoDB Configuration Files**
   Delete the MongoDB configuration files (usually found in `/etc`):
   ```bash
   sudo rm -rf /etc/mongod.conf
   ```

### 5. **Remove Additional MongoDB Files**
   Optionally, you may want to remove the MongoDB repository information if you added it during installation:
   ```bash
   sudo rm /etc/apt/sources.list.d/mongodb-org-*.list
   ```

### 6. **Update the Package List**
   Update the package list to ensure that MongoDB packages are completely removed:
   ```bash
   sudo apt-get autoremove
   sudo apt-get update
   ```

This process will remove MongoDB and all related files from your system. You can reinstall MongoDB later if needed.