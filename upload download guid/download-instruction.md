To download every file from your VPS server to your local machine, you can use several methods depending on the tools you have available and your operating system. Below are common methods using different tools:

### 1. Using `rsync` (Recommended for Linux/Mac)
`rsync` is a fast and versatile tool to sync files between your VPS and your local machine. It’s widely used because it supports resuming interrupted transfers and can handle large directories efficiently.

#### Steps:
1. **Open a terminal on your local machine.**
2. Run the following command:

   ```bash
   rsync -avzP user@your_vps_ip:/remote_directory_path/ /local_directory_path/
   ```

   Replace:
   - `user` with the username on the VPS.
   - `your_vps_ip` with the IP address or domain of your VPS.
   - `/remote_directory_path/` with the path to the directory you want to download from your VPS.
   - `/local_directory_path/` with the local path where you want the files to be saved.

#### Explanation:
- `-a`: Archive mode, preserves permissions, timestamps, etc.
- `-v`: Verbose, shows what is being transferred.
- `-z`: Compresses data during transfer.
- `-P`: Shows progress during the transfer and allows resuming in case of interruption.

### 2. Using `scp` (Linux/Mac)
`scp` is a secure way to copy files between a local machine and a remote machine.

#### Steps:
1. **Open a terminal on your local machine.**
2. Run the following command:

   ```bash
   scp -r user@your_vps_ip:/remote_directory_path/ /local_directory_path/
   ```

   Replace:
   - `user` with your VPS username.
   - `your_vps_ip` with the VPS IP address.
   - `/remote_directory_path/` with the remote directory you want to copy.
   - `/local_directory_path/` with the local directory where you want the files saved.

The `-r` option ensures that entire directories are copied recursively.

### 3. Using `SFTP` (Windows/Linux/Mac)

If you prefer a graphical interface, you can use an SFTP client like **FileZilla**.

#### Steps:
1. Download and install [FileZilla](https://filezilla-project.org/) or another SFTP client like **WinSCP** for Windows.
2. Open FileZilla and enter your VPS connection details at the top:
   - **Host**: `sftp://your_vps_ip`
   - **Username**: Your VPS username
   - **Password**: Your VPS password
   - **Port**: Use port `22` (default for SSH).
3. Once connected, navigate to the folder on your VPS that contains the files you want to download.
4. Drag and drop the files or directories to your local machine.

### 4. Using `tar` and `wget` (Linux/Mac)
If you have a large number of files, you can compress the entire directory into a `.tar` file, then download it with `wget`.

#### Steps:
1. **SSH into your VPS.**
2. Compress the desired directory into a `.tar` file:

   ```bash
   tar -czvf backup.tar.gz /path_to_directory/
   ```

   This will compress the directory into `backup.tar.gz`.

3. From your local machine, download the compressed file using `wget`:

   ```bash
   wget http://your_vps_ip/backup.tar.gz
   ```

   If you don't have a web server running on the VPS, you can use `scp` or `rsync` to download the compressed file.

4. Once downloaded, extract it on your local machine:

   ```bash
   tar -xzvf backup.tar.gz
   ```

### 5. Using SSHFS (Linux/Mac)
`sshfs` allows you to mount your VPS file system locally, so you can access all files directly as if they were on your local machine.

#### Steps:
1. Install `sshfs` on your local machine:

   - On Ubuntu/Debian:
     ```bash
     sudo apt-get install sshfs
     ```

   - On macOS:
     Install with Homebrew:
     ```bash
     brew install sshfs
     ```

2. Create a local directory where you want to mount your VPS files:

   ```bash
   mkdir ~/vps_mount
   ```

3. Mount the remote file system to the local directory:

   ```bash
   sshfs user@your_vps_ip:/remote_directory_path ~/vps_mount
   ```

   Now, you can access your VPS files in the `~/vps_mount` directory as if they were on your local machine.

### Notes:
- Make sure SSH access is properly configured on your VPS.
- If you encounter any firewall issues, ensure the correct port (e.g., `22` for SSH) is open on your VPS.

These methods should help you download every file from your VPS server. Let me know if you need further assistance!

To download everything from the `/var/www` directory on your VPS to your local machine, you can use one of the following methods. I'll assume your VPS allows SSH access.

### 1. **Using `rsync`** (Recommended)

`rsync` is efficient for copying large directories, and it can resume interrupted transfers.

#### Steps:
1. **Open a terminal on your local machine.**
2. Run this command to download everything from `/var/www` to your local directory:

   ```bash
   rsync -avzP user@your_vps_ip:/var/www/ /local_path_to_save_files/
   ```

   Replace:
   - `user` with your VPS username.
   - `your_vps_ip` with the IP address or domain of your VPS.
   - `/local_path_to_save_files/` with the local path where you want to save the downloaded files.

   Example:

   ```bash
   rsync -avzP root@123.45.67.89:/var/www/ ~/backup/www/
   ```

#### Explanation of the flags:
- `-a`: Archive mode, preserves permissions, timestamps, etc.
- `-v`: Verbose mode to see detailed output.
- `-z`: Compress the data during transfer.
- `-P`: Show progress and allow resuming interrupted transfers.

### 2. **Using `scp`**

You can use `scp` to copy the entire `/var/www` directory to your local machine.

#### Steps:
1. **Open a terminal on your local machine.**
2. Run the following command:

   ```bash
   scp -r user@your_vps_ip:/var/www/ /local_path_to_save_files/
   ```

   Example:

   ```bash
   scp -r root@123.45.67.89:/var/www/ ~/backup/www/
   ```

   - `-r`: Recursively copy all files and directories.
   - Replace `/local_path_to_save_files/` with the directory where you want to store the files on your local machine.

### 3. **Using `SFTP` with FileZilla or another SFTP client**

If you prefer a graphical interface, you can use **FileZilla** or **WinSCP** to download the files via SFTP.

#### Steps:
1. Download and install [FileZilla](https://filezilla-project.org/) or [WinSCP](https://winscp.net/eng/index.php) (for Windows).
2. Open the client and enter the following details:
   - **Host**: `sftp://your_vps_ip`
   - **Username**: Your VPS username.
   - **Password**: Your VPS password.
   - **Port**: `22` (SSH port).
3. Once connected, navigate to `/var/www` on the VPS.
4. Drag and drop the `/var/www` directory to a local directory on your machine.

### 4. **Using `tar` and `scp`**

If `/var/www` contains many files, you can first compress it into a single archive file and then download it.

#### Steps:
1. **SSH into your VPS** using a terminal:

   ```bash
   ssh user@your_vps_ip
   ```

2. Compress the `/var/www` directory into a `.tar.gz` file:

   ```bash
   sudo tar -czvf /tmp/www_backup.tar.gz /var/www/
   ```

3. **From your local machine**, download the compressed file using `scp`:

   ```bash
   scp user@your_vps_ip:/tmp/www_backup.tar.gz /local_path_to_save_files/
   ```

   Example:

   ```bash
   scp root@123.45.67.89:/tmp/www_backup.tar.gz ~/backup/
   ```

4. After downloading, **extract the tar file** on your local machine:

   ```bash
   tar -xzvf www_backup.tar.gz
   ```

### 5. **Using SSHFS**

If you want to access the `/var/www` directory directly from your local machine, you can mount it using SSHFS.

#### Steps:
1. **Install `sshfs`** on your local machine:

   - On Ubuntu/Debian:

     ```bash
     sudo apt-get install sshfs
     ```

   - On macOS:

     Install with Homebrew:

     ```bash
     brew install sshfs
     ```

2. **Mount the remote `/var/www` directory**:

   ```bash
   sshfs user@your_vps_ip:/var/www /local_mount_directory/
   ```

   Replace `/local_mount_directory/` with the path where you want to mount the remote directory.

3. You can now access and copy files from `/var/www` on your VPS as if it were a local directory.

---

These methods will help you download everything from the `/var/www` directory on your VPS to your local machine. Let me know if you need further clarification!

If you want to back up everything from the `/var/www` directory on your VPS to the `Downloads` folder on your Mac, you can easily do this using `rsync` or `scp`. Below are step-by-step instructions for both methods, targeting the `~/Downloads` folder on macOS.

### 1. **Using `rsync`**

`rsync` is a reliable option because it can resume interrupted transfers, and it preserves file permissions and timestamps. To back up your `/var/www` directory to your Mac's `Downloads` folder, follow these steps:

#### Steps:
1. **Open the Terminal on your Mac.**
2. Run the following command:

   ```bash
   rsync -avzP user@your_vps_ip:/var/www/ ~/Downloads/www_backup/
   ```

   Replace:
   - `user` with your VPS username (e.g., `root`).
   - `your_vps_ip` with the IP address or domain of your VPS.
   - `~/Downloads/www_backup/` is the path where the backup will be stored in your Mac’s `Downloads` folder. This will create a `www_backup` directory inside your `Downloads`.

#### Example:

```bash
rsync -avzP root@123.45.67.89:/var/www/ ~/Downloads/www_backup/
```

#### Explanation:
- `-a`: Archive mode (preserves permissions, timestamps, etc.).
- `-v`: Verbose mode (displays progress).
- `-z`: Compresses the data during transfer to reduce bandwidth usage.
- `-P`: Shows progress and allows the transfer to be resumed if interrupted.

### 2. **Using `scp`**

`scp` is simpler and works in one step, but it does not handle resuming interrupted transfers as well as `rsync`.

#### Steps:
1. **Open the Terminal on your Mac.**
2. Run the following command:

   ```bash
   scp -r user@your_vps_ip:/var/www/ ~/Downloads/www_backup/
   ```

   Replace:
   - `user` with your VPS username (e.g., `root`).
   - `your_vps_ip` with the IP address or domain of your VPS.
   - `~/Downloads/www_backup/` with the path where the backup will be saved on your Mac.

#### Example:

```bash
scp -r root@123.45.67.89:/var/www/ ~/Downloads/www_backup/
```

- The `-r` option means recursive, ensuring that the entire `/var/www/` directory and all its subdirectories are copied.
  
### 3. **Using `tar` and `scp` for Larger Backups**

For large directories, compressing everything into a single `.tar.gz` archive on the VPS and then transferring the compressed file can save time and bandwidth.

#### Steps:

1. **SSH into your VPS** and compress the `/var/www` directory:

   ```bash
   ssh user@your_vps_ip
   sudo tar -czvf /tmp/www_backup.tar.gz /var/www/
   ```

2. **From your Mac**, use `scp` to download the compressed archive to your `Downloads` folder:

   ```bash
   scp user@your_vps_ip:/tmp/www_backup.tar.gz ~/Downloads/
   ```

3. Once the file is in your `Downloads` folder, **extract it** on your Mac:

   ```bash
   cd ~/Downloads
   tar -xzvf www_backup.tar.gz
   ```

This will extract the contents of `/var/www` into the `Downloads` folder on your Mac.

### Summary of Commands

1. **`rsync` (recommended)**:
   ```bash
   rsync -avzP user@your_vps_ip:/var/www/ ~/Downloads/www_backup/
   ```

2. **`scp`**:
   ```bash
   scp -r user@your_vps_ip:/var/www/ ~/Downloads/www_backup/
   ```

3. **`tar` + `scp` for large backups**:
   ```bash
   # Step 1: Compress on VPS
   sudo tar -czvf /tmp/www_backup.tar.gz /var/www/

   # Step 2: Download the compressed file to Mac's Downloads
   scp user@your_vps_ip:/tmp/www_backup.tar.gz ~/Downloads/

   # Step 3: Extract the backup on Mac
   cd ~/Downloads
   tar -xzvf www_backup.tar.gz
   ```

Let me know if you need any further assistance or adjustments!

The error message you received indicates that `rsync` is trying to find files on your local machine (`/Users/minhaj/Documents/...`) rather than connecting to your VPS and accessing the remote files. This typically happens when the command is structured incorrectly, particularly with how you are specifying the remote source and destination paths.

Here’s the fix:

### Correct `rsync` Command
Make sure the remote directory is properly specified with the correct user and server address, and the local destination directory is correct.

#### The corrected command should look like this:

```bash
rsync -avzP user@142.93.236.178:/var/www/payment.easyonwardticket.com/ ~/Downloads/www_backup/
```

### Key things to ensure:
1. **User and VPS IP/Domain**: Replace `user` with your VPS username (e.g., `root` if you're using the root account), and make sure the IP `142.93.236.178` is correct.
2. **Remote Path**: Ensure `/var/www/payment.easyonwardticket.com/` exists on the VPS. The trailing `/` after the directory path is important to indicate you want the contents of the directory to be synced.
3. **Local Path**: `~/Downloads/www_backup/` is the directory on your local Mac where the files will be saved. Make sure it’s the right destination, or create this directory if it doesn’t exist.

#### Example:

If you're using `root` as the user, the command would be:

```bash
rsync -avzP root@142.93.236.178:/var/www/payment.easyonwardticket.com/ ~/Downloads/www_backup/
```

### Explanation of the error:

- The error occurred because `rsync` was interpreting the path incorrectly as a local directory rather than a remote one.
- By adding the correct user and remote server IP before the path (`root@142.93.236.178:/var/www/...`), `rsync` will correctly connect to the remote VPS and start transferring the files.

### Additional Notes:
- Ensure that SSH access is correctly set up between your local machine and the VPS.
- If the `~/Downloads/www_backup/` folder doesn’t exist on your Mac, you can create it using:

  ```bash
  mkdir -p ~/Downloads/www_backup/
  ```

Try this and let me know if it works!

The error message you are encountering indicates that there is a problem with the authentication process when trying to connect to your VPS. Specifically, it’s saying "Permission denied (publickey,password)", which means that `rsync` is trying to connect but is not able to authenticate you properly using either your SSH public key or password.

Here are some steps to troubleshoot and resolve the issue:

### Step 1: Verify SSH Access

First, ensure that you can SSH into your VPS directly, without using `rsync`, to verify if the problem lies in the SSH connection.

Run this command in your terminal:

```bash
ssh user@142.93.236.178
```

- Replace `user` with your actual VPS username (e.g., `root` if you use the root account).
- You’ll be prompted for your password if you’re using password-based authentication.

If you cannot log in with SSH, there might be an issue with your SSH configuration, password, or the SSH server configuration on the VPS.

### Step 2: Use the Correct Username

Make sure that the `user` you are using in the `rsync` or `ssh` command is correct. If your VPS uses `root`, modify the command accordingly.

For example, if your username is `root`, use:

```bash
rsync -avzP root@142.93.236.178:/var/www/payment.easyonwardticket.com/ ~/Downloads/www_backup/
```

### Step 3: Check if Password-Based Authentication is Allowed

Your VPS might be configured to only accept public key authentication and not password authentication. To check and fix this:

1. **Log in via SSH** (if you have access) and edit the SSH configuration file:

   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

2. Look for the following lines:
   - `PasswordAuthentication no`
   - `PermitRootLogin no` or `PermitRootLogin prohibit-password`

3. If `PasswordAuthentication` is set to `no`, change it to `yes`:

   ```bash
   PasswordAuthentication yes
   ```

4. Restart the SSH service on your VPS:

   ```bash
   sudo systemctl restart ssh
   ```

5. Try logging in again.

### Step 4: Use SSH Key Authentication

If password-based login is not working, it is highly recommended to use SSH key authentication, which is both secure and convenient. Here's how you can set it up:

#### On your local machine (Mac):
1. **Generate an SSH key pair** (if you don’t already have one):

   ```bash
   ssh-keygen -t rsa
   ```

   Press `Enter` to save the key to the default location (`~/.ssh/id_rsa`).

2. **Copy your public key to the VPS**:

   Use the `ssh-copy-id` command to copy your SSH key to the VPS:

   ```bash
   ssh-copy-id user@142.93.236.178
   ```

   Replace `user` with your VPS username.

   This command will prompt for your VPS password one last time, and then it will copy your public key to the server.

3. After this, you should be able to log in without a password. Try running the `rsync` command again:

   ```bash
   rsync -avzP user@142.93.236.178:/var/www/payment.easyonwardticket.com/ ~/Downloads/www_backup/
   ```

#### If you prefer to manually copy your SSH key:
1. On your local machine, print out the contents of your public key:

   ```bash
   cat ~/.ssh/id_rsa.pub
   ```

2. **On the VPS**, edit the `~/.ssh/authorized_keys` file and paste your public key there.

3. Set proper permissions:

   ```bash
   chmod 600 ~/.ssh/authorized_keys
   ```

### Step 5: Debug SSH Connection

If none of the above works, you can run SSH with debugging information to see more details about the issue. Run this command:

```bash
ssh -v user@142.93.236.178
```

This will give you verbose output, which can help pinpoint why the connection is being denied.

### Step 6: Recheck Firewall and SSH Port

Ensure that:
- Port `22` (or your custom SSH port) is open.
- You are using the correct port. If SSH runs on a non-standard port, you can specify it with the `-p` option in both `ssh` and `rsync`.

Example for port `2222`:

```bash
rsync -avzP -e "ssh -p 2222" user@142.93.236.178:/var/www/payment.easyonwardticket.com/ ~/Downloads/www_backup/
```

---

Let me know how it goes after following these steps or if you encounter any specific issues during any of the steps!