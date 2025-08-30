To install a fresh version of Apache2 on your system, follow these steps:

### 1. Update Package List
Ensure your package list is up-to-date:

```bash
sudo apt-get update
```

### 2. Install Apache2
Install Apache2 using the following command:

```bash
sudo apt-get install apache2
```

### 3. Verify Apache2 Installation
After installation, check the Apache2 status to ensure it’s running:

```bash
sudo systemctl status apache2
```

If it’s running, you’ll see an "active (running)" status. You can also verify by opening your browser and visiting `http://localhost`. If Apache is working, you should see the default Apache welcome page.

### 4. Enable Apache2 to Start on Boot (Optional)
To ensure Apache2 starts automatically on boot, use:

```bash
sudo systemctl enable apache2
```

Apache2 is now freshly installed and set up on your system!

To completely remove Apache2 from your system, you can follow these steps:

### 1. Stop Apache2 Service
First, stop the Apache2 service to ensure it's not running:

```bash
sudo systemctl stop apache2
```

### 2. Uninstall Apache2 Packages
Use the following command to remove Apache2 and all its associated packages:

```bash
sudo apt-get purge apache2 apache2-utils apache2-bin apache2.2-common
```

### 3. Remove Configuration Files and Directories
Delete all configuration files and directories related to Apache2:

```bash
sudo rm -rf /etc/apache2
```

### 4. Remove Any Leftover Dependencies
To remove any packages that were installed as dependencies and are no longer needed:

```bash
sudo apt-get autoremove
```

### 5. Clean Up Residual Files (Optional)
To clean up any remaining cached files from removed packages:

```bash
sudo apt-get autoclean
```

After completing these steps, Apache2 should be completely removed from your system. You can check this by running:

```bash
apache2 -v
```

If Apache2 is still installed, this command will display its version; otherwise, it will return an error indicating it’s uninstalled.