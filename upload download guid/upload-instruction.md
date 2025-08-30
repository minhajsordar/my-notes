To upload everything from the `/Download/www_backup` directory on your local machine to `/var/www` on your Linux server, you can use `rsync` or `scp` commands over SSH. Here's how you can do it using both methods.

### Using `rsync`:
`rsync` is generally preferred for transferring files because it is efficient, especially when only some files have changed.

1. Open a terminal on your local machine.
2. Run the following command:

```bash
rsync -avz /path/to/Download/www_backup/ username@server_ip:/var/www/
```

- Replace `/path/to/Download/www_backup/` with the actual path to the directory on your local machine.
- Replace `username` with the username for the Linux server.
- Replace `server_ip` with the IP address or domain name of your server.

The `-avz` flags mean:
- `-a`: Archive mode (preserves permissions, symbolic links, etc.)
- `-v`: Verbose output (shows progress)
- `-z`: Compress file data during the transfer

### Using `scp`:
`scp` (Secure Copy) is simpler but transfers everything every time.

1. Open a terminal on your local machine.
2. Run the following command:

```bash
scp -r /path/to/Download/www_backup/ username@server_ip:/var/www/
```

- Replace `/path/to/Download/www_backup/` with the actual path to the directory on your local machine.
- Replace `username` with your Linux server's username.
- Replace `server_ip` with the IP address or domain name of your server.
- The `-r` flag means recursive, to copy directories and their contents.

### Example for both:
If your backup directory is located at `/home/user/Download/www_backup/` and your server's IP is `192.168.1.10` with the user `admin`, you would use:

For `rsync`:

```bash
rsync -avz /home/user/Download/www_backup/ admin@192.168.1.10:/var/www/
```

For `scp`:

```bash
scp -r /home/user/Download/www_backup/ admin@192.168.1.10:/var/www/
```

Make sure you have the necessary permissions on your server to write to `/var/www`, and you may need to use `sudo` on the server side to manage files in that directory, depending on your setup.