sudo apt update
sudo apt install screen
## list 
screen -ls
## reattach
screen -r ID-name
screen -r 1268
screen -r session1
screen -r begunipikbackend
screen -r begunipik
screen -r linksharingapp
## force detach and reattach
screen -d -r begunipikbackend
screen -d -r begunipik

## create with named screen
screen -S session_name
screen -S begunipikbackend
screen -S begunipik
screen -S linksharingapp

## detach
Ctrl + A, then D

Creating a new screen session in a Unix-based system (like Linux or macOS) using the `screen` command allows you to start a new terminal session that you can detach from and reattach to later. This is useful for running long-term processes or keeping sessions alive even if you disconnect from your SSH session. Here's how to create and manage screen sessions:

### 1. **Install `screen` (if not already installed)**
   - On Debian/Ubuntu-based systems:
     ```bash
     sudo apt-get install screen
     ```
   - On Red Hat/CentOS-based systems:
     ```bash
     sudo yum install screen
     ```
   - On macOS, you can use Homebrew:
     ```bash
     brew install screen
     ```

### 2. **Create a New Screen Session**
   - To start a new screen session, simply type:
     ```bash
     screen
     ```
   - This will create a new session and bring you into it. You can start working within this screen session as if it were a normal terminal window.

### 3. **Name Your Screen Session**
   - It's a good idea to name your screen sessions, especially if you plan to have multiple sessions running. To name a session:
     ```bash
     screen -S session_name
     ```
   - Replace `session_name` with a descriptive name for your session.

### 4. **Detach from the Screen Session**
   - To detach from the screen session without killing it (leaving it running in the background), press:
     ```
     Ctrl + A, then D
     ```
   - This will return you to your original terminal, but the screen session will continue running in the background.

### 5. **List Active Screen Sessions**
   - To see a list of all active screen sessions, use:
     ```bash
     screen -ls
     ```
   - This will show all the running screen sessions along with their IDs and names.

### 6. **Reattach to a Screen Session**
   - To reattach to a detached screen session, use:
     ```bash
     screen -r session_name
     ```
   - If you have multiple sessions and did not name them, you can reattach using the session ID:
     ```bash
     screen -r session_id
     ```

### 7. **Close a Screen Session**
   - To exit and close a screen session, type `exit` within the screen session, and it will terminate that session:
     ```bash
     exit
     ```

### 8. **Force Detach and Reattach**
   - If you need to reattach to a session that is already attached elsewhere (for example, you were disconnected), you can use:
     ```bash
     screen -d -r session_name
     ```
   - This will detach the session from wherever it is currently attached and reattach it to your current terminal.

By following these steps, you can create, manage, and effectively use `screen` sessions for long-running processes or maintaining persistent terminal sessions.