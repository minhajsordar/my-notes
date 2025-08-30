It's great that you're setting up a CI/CD pipeline for your React project! However, **please refrain from sharing sensitive information** such as server passwords publicly. Instead, it's best practice to use **GitHub Secrets** to securely manage sensitive data in your workflows.

Below, I'll guide you through modifying your GitHub Actions workflow to:

1. **Build and test your React project on push or pull request to the `main` branch.**
2. **Deploy the built project to your server when changes are pushed to the `main` branch.**

### Step 1: Set Up GitHub Secrets

First, store your server credentials securely using GitHub Secrets:

1. **Navigate to your repository on GitHub.**
2. **Go to `Settings` > `Secrets and variables` > `Actions`.**
3. **Click on `New repository secret` and add the following secrets:**
   - `SERVER_HOST` – e.g., `142.23.536.174`
   - `SERVER_USER` – e.g., `root`
   - `SERVER_PASSWORD` – *Your server password*

   > **Note:** For enhanced security, it's recommended to use SSH keys instead of passwords. If possible, generate an SSH key pair and add the private key as a secret (e.g., `SSH_PRIVATE_KEY`) and the public key to your server's `~/.ssh/authorized_keys`.

### Step 2: Modify Your GitHub Actions Workflow

Here's the updated workflow that includes deployment steps. This workflow:

- **Triggers on pushes and pull requests to the `main` branch.**
- **Builds and tests the React project.**
- **Deploys the built project to your server when changes are pushed to `main`.**

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x]
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:
      - uses: actions/checkout@v4

      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - run: npm ci

      - run: npm run build --if-present

      - run: npm test

      # Deploy step: Only runs on push to main
      - name: Deploy to Server
        if: github.event_name == 'push'
        uses: appleboy/scp-action@v0.1.3
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          password: ${{ secrets.SERVER_PASSWORD }}
          port: 22
          source: "build/"
          target: "/var/www/react"

      # Alternatively, using SSH to run commands on the server
      - name: Deploy via SSH
        if: github.event_name == 'push'
        uses: appleboy/ssh-action@v0.1.3
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          password: ${{ secrets.SERVER_PASSWORD }}
          port: 22
          script: |
            cd /var/www/react
            git pull origin main
            npm install
            npm run build
```

### Explanation of the Workflow

1. **Triggers (`on`):**
   - **`push` and `pull_request`** events on the `main` branch trigger the workflow.

2. **Jobs:**
   - **`build`:** Handles building and testing your React project.
   
3. **Steps:**
   - **Checkout Code:** Uses `actions/checkout@v4` to pull your repository code.
   - **Setup Node.js:** Sets up the specified Node.js version.
   - **Install Dependencies:** Runs `npm ci` to install dependencies.
   - **Build Project:** Executes `npm run build` to build the React project.
   - **Run Tests:** Runs `npm test` to execute your test suite.
   
4. **Deployment Steps:**
   - **Deploy to Server:** Uses the [`appleboy/scp-action`](https://github.com/appleboy/scp-action) to securely copy the built files from the `build/` directory to your server's `/var/www/react` directory.
     - **Condition:** Only runs on `push` events to `main`.
   
   - **Deploy via SSH:** Alternatively, you can execute commands on your server using the [`appleboy/ssh-action`](https://github.com/appleboy/ssh-action).
     - **Condition:** Only runs on `push` events to `main`.
     - **Script:** Navigates to the project directory, pulls the latest changes, installs dependencies, and builds the project.

### Security Recommendations

- **Use SSH Keys Instead of Passwords:** SSH keys are more secure than passwords. Here's how you can set it up:
  1. **Generate an SSH Key Pair** on your local machine:
     ```bash
     ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
     ```
  2. **Add the Public Key** to your server's `~/.ssh/authorized_keys`.
  3. **Add the Private Key** as a GitHub Secret (e.g., `SSH_PRIVATE_KEY`).
  4. **Modify the Workflow** to use the SSH key for authentication.

- **Limit Permissions:** Ensure that the SSH user has only the necessary permissions to deploy the application.

- **Regularly Rotate Secrets:** Update your secrets periodically to enhance security.

### Final Notes

Ensure that the `build/` directory (or the directory where your React app is built) is correctly specified in the `source` field of the `scp-action`. Adjust the `target` path as needed based on your server's configuration.

By following these steps, you'll have a secure and efficient CI/CD pipeline that builds, tests, and deploys your React application automatically upon changes to the `main` branch.



Certainly! Let me clarify what I meant by "**Alternatively, using SSH to run commands on the server**" and how it differs from simply copying files using SCP. Understanding these two approaches will help you choose the best deployment strategy for your specific needs.

### **1. Deploying with SCP (Secure Copy Protocol)**

**What It Does:**
- **File Transfer:** The `appleboy/scp-action` copies your built React project's files (typically from the `build/` directory) directly to a specified directory on your server (e.g., `/var/www/react`).

**Workflow Step:**
```yaml
- name: Deploy to Server
  if: github.event_name == 'push'
  uses: appleboy/scp-action@v0.1.3
  with:
    host: ${{ secrets.SERVER_HOST }}
    username: ${{ secrets.SERVER_USER }}
    password: ${{ secrets.SERVER_PASSWORD }}
    port: 22
    source: "build/"
    target: "/var/www/react"
```

**Advantages:**
- **Simplicity:** Straightforward method to transfer files.
- **Speed:** Quick transfer of static assets without additional steps.
- **Minimal Server Setup:** Doesn't require Git or Node.js on the server if serving static files.

**Use Cases:**
- **Static Deployments:** Ideal for static websites or applications that don’t require server-side processing.
- **Quick Updates:** When you only need to update the frontend assets without modifying server configurations.

**Limitations:**
- **No Build on Server:** The build process occurs locally (in GitHub Actions), so any server-side dependencies or configurations need to be handled separately.
- **Limited Flexibility:** Less control over server-side operations, such as restarting services or handling environment variables.

---

### **2. Deploying via SSH to Run Commands on the Server**

**What It Does:**
- **Remote Command Execution:** The `appleboy/ssh-action` allows you to execute a series of commands on your server via SSH. This can include pulling the latest code, installing dependencies, building the project, and restarting services.

**Workflow Step:**
```yaml
- name: Deploy via SSH
  if: github.event_name == 'push'
  uses: appleboy/ssh-action@v0.1.3
  with:
    host: ${{ secrets.SERVER_HOST }}
    username: ${{ secrets.SERVER_USER }}
    password: ${{ secrets.SERVER_PASSWORD }}
    port: 22
    script: |
      cd /var/www/react
      git pull origin main
      npm install
      npm run build
      pm2 restart all  # Example: Restarting a Node.js process manager
```

**Advantages:**
- **Comprehensive Deployment:** Ability to execute multiple commands ensures that the server environment is properly set up and updated.
- **Flexibility:** Can handle complex deployment scenarios, such as database migrations, service restarts, and environment variable updates.
- **Server-Side Builds:** If you prefer building on the server (useful for certain configurations or when you want to keep build artifacts off your CI/CD pipeline).

**Use Cases:**
- **Dynamic Applications:** Suitable for applications that require server-side processing, such as APIs or server-rendered apps.
- **Complex Deployments:** When deployment involves more than just copying files, like migrating databases, clearing caches, or restarting services.
- **Continuous Integration:** When you want the server to handle certain aspects of the deployment process.

**Limitations:**
- **Server Requirements:** Your server needs to have the necessary tools installed (e.g., Git, Node.js, build tools).
- **Security Concerns:** Executing commands on the server requires careful management of SSH keys and permissions to prevent unauthorized access.
- **Potential for Errors:** More steps mean more points where things can go wrong, requiring robust error handling.

---

### **Choosing Between SCP and SSH Deployments**

**When to Use SCP:**
- **Static Sites:** If your React app is purely frontend and doesn't require server-side processing.
- **Simple Updates:** When deployments only involve updating frontend assets without altering server configurations.
- **Limited Server Access:** If you prefer not to allow extensive command execution on your server.

**When to Use SSH:**
- **Full-Stack Applications:** If your application includes backend services that need to be updated alongside the frontend.
- **Automated Server Management:** When you need to perform additional server-side tasks during deployment.
- **Environment Consistency:** To ensure that the server environment is correctly set up each time you deploy.

---

### **Enhancing Security with SSH Keys**

While both methods can use passwords for authentication, **SSH keys** are a more secure and recommended approach. Here's how you can set it up:

1. **Generate an SSH Key Pair:**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```
   - **Private Key:** Keep this secure and add it as a GitHub Secret (e.g., `SSH_PRIVATE_KEY`).
   - **Public Key:** Add this to your server's `~/.ssh/authorized_keys` file.

2. **Update GitHub Actions Workflow:**
   Modify the deployment steps to use the SSH key instead of a password.

   **Using SCP with SSH Key:**
   ```yaml
   - name: Deploy to Server
     if: github.event_name == 'push'
     uses: appleboy/scp-action@v0.1.3
     with:
       host: ${{ secrets.SERVER_HOST }}
       username: ${{ secrets.SERVER_USER }}
       key: ${{ secrets.SSH_PRIVATE_KEY }}
       port: 22
       source: "build/"
       target: "/var/www/react"
   ```

   **Using SSH with SSH Key:**
   ```yaml
   - name: Deploy via SSH
     if: github.event_name == 'push'
     uses: appleboy/ssh-action@v0.1.3
     with:
       host: ${{ secrets.SERVER_HOST }}
       username: ${{ secrets.SERVER_USER }}
       key: ${{ secrets.SSH_PRIVATE_KEY }}
       port: 22
       script: |
         cd /var/www/react
         git pull origin main
         npm install
         npm run build
         pm2 restart all  # Example: Restarting a Node.js process manager
   ```

3. **Benefits of Using SSH Keys:**
   - **Enhanced Security:** SSH keys are less susceptible to brute-force attacks compared to passwords.
   - **Automation-Friendly:** Easier to manage for automated workflows without exposing passwords.
   - **Access Control:** You can restrict the SSH key's permissions on the server, limiting what actions the CI/CD pipeline can perform.

---

### **Example: Complete GitHub Actions Workflow with SSH Deployment**

Here's how you can integrate SSH-based deployment using SSH keys into your GitHub Actions workflow:

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x]
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:
      - uses: actions/checkout@v4

      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - run: npm ci

      - run: npm run build --if-present

      - run: npm test

      # Deploy step: Only runs on push to main
      - name: Deploy via SSH
        if: github.event_name == 'push'
        uses: appleboy/ssh-action@v0.1.3
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: 22
          script: |
            cd /var/www/react
            git pull origin main
            npm install
            npm run build
            pm2 restart all  # Example: Restarting a Node.js process manager
```

**Notes:**
- **Ensure Git is Installed on the Server:** The `git pull` command requires Git to be installed on your server.
- **Process Manager:** If you're using a process manager like PM2 to manage your Node.js applications, ensure it's installed and configured on your server.
- **Environment Variables:** Manage any necessary environment variables securely, possibly using `.env` files or server-side configuration tools.

---

### **Conclusion**

**"Alternatively, using SSH to run commands on the server"** refers to executing a series of deployment-related commands directly on your server via an SSH connection. This method offers greater flexibility and control over the deployment process, allowing you to perform complex operations beyond just copying files.

**Choosing between SCP and SSH deployments depends on:**
- **Complexity of Your Application:** Static vs. dynamic/full-stack.
- **Deployment Requirements:** Simple file updates vs. comprehensive server-side configurations.
- **Security Considerations:** Preference for SSH keys over passwords.
- **Server Environment:** Availability of necessary tools and permissions.

By understanding both approaches, you can tailor your CI/CD pipeline to best fit your project's needs, ensuring efficient and secure deployments.

If you have any further questions or need assistance with specific aspects of the deployment process, feel free to ask!


Certainly! Below is a complete **GitHub Actions** workflow YAML file that:

1. **Triggers** on pushes and pull requests to the `main` branch.
2. **Builds and tests** your React project.
3. **Deploys** the built project to your server's `/var/www/react` directory **only** when changes are pushed to the `main` branch.

### **Security First: Use SSH Keys Instead of Passwords**

**Important:** It's highly recommended to use **SSH keys** for authentication instead of passwords. SSH keys are more secure and facilitate smoother automated deployments.

#### **Step 1: Generate SSH Keys**

1. **Generate an SSH Key Pair** on your local machine (if you don't have one already):

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

   - **Save the key** (e.g., `id_rsa_github`) without a passphrase for automation purposes.

2. **Add the Public Key** (`id_rsa_github.pub`) to your server's `~/.ssh/authorized_keys`:

   ```bash
   ssh root@142.23.536.174
   # Once logged in, run:
   mkdir -p ~/.ssh
   echo "your_public_key_contents" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```

#### **Step 2: Add SSH Private Key to GitHub Secrets**

1. **Navigate to your repository on GitHub.**
2. **Go to** `Settings` > `Secrets and variables` > `Actions`.
3. **Click on** `New repository secret` and add the following secrets:
   - `SERVER_HOST` – e.g., `142.23.536.174`
   - `SERVER_USER` – e.g., `root`
   - `SSH_PRIVATE_KEY` – *Your SSH private key content (`id_rsa_github`)*

   > **Note:** Ensure there are no extra spaces or newline characters when copying the private key.

#### **Step 3: Create the GitHub Actions Workflow**

Create a file named `.github/workflows/ci-cd.yml` in your repository and paste the following YAML code:

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x]
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:
      # Step 1: Checkout the repository
      - uses: actions/checkout@v4

      # Step 2: Set up Node.js
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      # Step 3: Install dependencies
      - name: Install Dependencies
        run: npm ci

      # Step 4: Build the React project
      - name: Build Project
        run: npm run build --if-present

      # Step 5: Run tests
      - name: Run Tests
        run: npm test

      # Step 6: Deploy to Server (Only on push to main)
      - name: Deploy to Server via SSH
        if: github.event_name == 'push'
        uses: appleboy/ssh-action@v0.1.3
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: 22
          # The script to execute on the server
          script: |
            # Navigate to the React app directory
            cd /var/www/react

            # (Optional) If you're using Git on the server, pull the latest changes
            # git pull origin main

            # Install dependencies
            npm install

            # Build the project (if not built locally)
            npm run build

            # Restart the server or any process manager (e.g., PM2)
            # Example with PM2:
            # pm2 restart all

            # If serving static files with a web server like Nginx, you might need to reload it
            # sudo systemctl reload nginx

            echo "Deployment completed successfully!"
```

### **Explanation of the Workflow**

1. **Triggers (`on`):**
   - **`push`** and **`pull_request`** events on the `main` branch trigger the workflow.

2. **Jobs:**
   - **`build`:** Handles building and testing your React project.

3. **Steps:**
   - **Checkout Code:** Uses `actions/checkout@v4` to clone your repository.
   - **Setup Node.js:** Sets up the specified Node.js version with caching enabled for `npm`.
   - **Install Dependencies:** Runs `npm ci` to install dependencies cleanly.
   - **Build Project:** Executes `npm run build` to build the React project.
   - **Run Tests:** Runs `npm test` to execute your test suite.
   - **Deploy to Server:** Uses [`appleboy/ssh-action`](https://github.com/appleboy/ssh-action) to execute deployment commands on your server **only** when changes are pushed to `main`.

### **Customizing the Deployment Script**

- **Git Integration (Optional):**
  - If you prefer to manage your project with Git on the server, uncomment the `git pull origin main` line. Ensure that the server has Git installed and is set up to pull from your repository.

- **Process Manager (Optional):**
  - If you're using a process manager like **PM2** to manage your Node.js applications, ensure it's installed on your server and uncomment the `pm2 restart all` line to restart your application after deployment.

- **Web Server Reload (Optional):**
  - If you're serving your React app with a web server like **Nginx**, you might need to reload or restart the service after deployment. Uncomment and modify the `sudo systemctl reload nginx` line as needed.

- **Build on Server vs. Locally:**
  - In the provided workflow, the React project is built locally within GitHub Actions. If you prefer to build on the server instead, you can remove the build step from the workflow and handle it entirely on the server.

### **Additional Recommendations**

- **Environment Variables:**
  - If your React application relies on environment variables, ensure they are properly set on the server. You can manage them using `.env` files or server-side configuration tools.

- **File Permissions:**
  - Ensure that the `/var/www/react` directory has the appropriate permissions for the `SERVER_USER` to read and write.

- **Firewall and SSH Access:**
  - Make sure that your server's firewall allows SSH connections on port `22` and that the `SERVER_USER` has the necessary permissions to execute the deployment scripts.

- **Testing Deployment:**
  - After setting up the workflow, perform a test push to the `main` branch to verify that the CI/CD pipeline works as expected and that the deployment occurs successfully.

### **Alternative: Deploying with SCP Instead of SSH Commands**

If you prefer to **copy the built files directly** to your server without executing remote commands, you can use the `appleboy/scp-action`. Here's how to modify the workflow:

1. **Add `SERVER_PASSWORD` to GitHub Secrets** (if not using SSH keys). However, **SSH keys are recommended** for security reasons.

2. **Modify the Deployment Step:**

   ```yaml
   # Deploy to Server via SCP
   - name: Deploy to Server via SCP
     if: github.event_name == 'push'
     uses: appleboy/scp-action@v0.1.3
     with:
       host: ${{ secrets.SERVER_HOST }}
       username: ${{ secrets.SERVER_USER }}
       key: ${{ secrets.SSH_PRIVATE_KEY }}  # Or use 'password: ${{ secrets.SERVER_PASSWORD }}' if using a password
       port: 22
       source: "build/"
       target: "/var/www/react"
   ```

**Note:** Using SCP alone copies the files but doesn't handle tasks like installing dependencies or restarting services. Combining SCP with SSH commands provides a more robust deployment process.

### **Final Thoughts**

By following the above steps and using the provided YAML configuration, you'll have a secure and efficient CI/CD pipeline that builds, tests, and deploys your React application automatically upon changes to the `main` branch.

**Remember:**
- **Never share sensitive information** like passwords publicly.
- **Regularly rotate your SSH keys** and ensure they have the minimal required permissions.
- **Monitor your deployments** to catch and address any issues promptly.

If you encounter any issues or have further questions, feel free to ask!


Certainly! Below is the **GitHub Actions** workflow YAML file tailored for a React project that uses **Yarn** instead of **npm**. This workflow will:

1. **Trigger** on pushes and pull requests to the `main` branch.
2. **Build and test** your React project using Yarn.
3. **Deploy** the built project to your server's `/var/www/react` directory **only** when changes are pushed to the `main` branch.

### **Security Reminder: Use SSH Keys Instead of Passwords**

**Important:** Always use **SSH keys** for authentication instead of passwords. SSH keys are more secure and facilitate smoother automated deployments. Ensure you've followed these steps:

1. **Generate an SSH Key Pair** (if you haven't already).
2. **Add the Public Key** to your server's `~/.ssh/authorized_keys`.
3. **Add the Private Key** as a GitHub Secret (`SSH_PRIVATE_KEY`).

### **Step-by-Step Guide**

#### **Step 1: Generate SSH Keys (If Not Already Done)**

1. **Generate an SSH Key Pair** on your local machine:
   
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa_github
   ```
   
   - **Private Key:** `~/.ssh/id_rsa_github`
   - **Public Key:** `~/.ssh/id_rsa_github.pub`

2. **Add the Public Key** to your server:

   ```bash
   ssh root@142.23.536.174
   # Once logged in, run:
   mkdir -p ~/.ssh
   echo "your_public_key_contents" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```

#### **Step 2: Add SSH Private Key to GitHub Secrets**

1. **Navigate to your repository on GitHub.**
2. **Go to** `Settings` > `Secrets and variables` > `Actions`.
3. **Click on** `New repository secret` and add the following secrets:
   - `SERVER_HOST` – e.g., `142.23.536.174`
   - `SERVER_USER` – e.g., `root`
   - `SSH_PRIVATE_KEY` – *Your SSH private key content (`id_rsa_github`)*

   > **Note:** Ensure there are no extra spaces or newline characters when copying the private key.

#### **Step 3: Create the GitHub Actions Workflow**

Create a file named `.github/workflows/ci-cd.yml` in your repository and paste the following YAML code:

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x]
        # See supported Node.js release schedule at https://nodejs.org/en/about/releases/

    steps:
      # Step 1: Checkout the repository
      - uses: actions/checkout@v4

      # Step 2: Set up Node.js with Yarn caching
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'yarn'

      # Step 3: Install dependencies using Yarn
      - name: Install Dependencies
        run: yarn install --frozen-lockfile

      # Step 4: Build the React project
      - name: Build Project
        run: yarn build

      # Step 5: Run tests
      - name: Run Tests
        run: yarn test

      # Step 6: Deploy to Server via SSH (Only on push to main)
      - name: Deploy to Server via SSH
        if: github.event_name == 'push'
        uses: appleboy/ssh-action@v0.1.3
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: 22
          script: |
            # Navigate to the React app directory
            cd /var/www/react

            # (Optional) If you're using Git on the server, pull the latest changes
            # git pull origin main

            # Install dependencies
            yarn install --frozen-lockfile

            # Build the project (if not built locally)
            yarn build

            # Restart the server or any process manager (e.g., PM2)
            # Example with PM2:
            # pm2 restart all

            # If serving static files with a web server like Nginx, you might need to reload it
            # sudo systemctl reload nginx

            echo "Deployment completed successfully!"
```

### **Explanation of the Workflow**

1. **Triggers (`on`):**
   - **`push`** and **`pull_request`** events on the `main` branch trigger the workflow.

2. **Jobs:**
   - **`build`:** Handles building and testing your React project.

3. **Steps:**
   - **Checkout Code:** Uses `actions/checkout@v4` to clone your repository.
   - **Setup Node.js:** Sets up the specified Node.js version with caching enabled for Yarn.
   - **Install Dependencies:** Runs `yarn install --frozen-lockfile` to install dependencies consistently based on the lock file.
   - **Build Project:** Executes `yarn build` to build the React project.
   - **Run Tests:** Runs `yarn test` to execute your test suite.
   - **Deploy to Server:** Uses [`appleboy/ssh-action`](https://github.com/appleboy/ssh-action) to execute deployment commands on your server **only** when changes are pushed to `main`.

### **Customizing the Deployment Script**

- **Git Integration (Optional):**
  - If you prefer to manage your project with Git on the server, uncomment the `git pull origin main` line. Ensure that Git is installed on your server and that the repository is properly set up.

- **Process Manager (Optional):**
  - If you're using a process manager like **PM2** to manage your Node.js applications, ensure it's installed on your server and uncomment the `pm2 restart all` line to restart your application after deployment.

- **Web Server Reload (Optional):**
  - If you're serving your React app with a web server like **Nginx**, you might need to reload or restart the service after deployment. Uncomment and modify the `sudo systemctl reload nginx` line as needed.

- **Build on Server vs. Locally:**
  - In this workflow, the React project is built locally within GitHub Actions. If you prefer to build on the server instead, you can remove the build step from the workflow and handle it entirely on the server.

### **Additional Recommendations**

- **Environment Variables:**
  - If your React application relies on environment variables, ensure they are properly set on the server. You can manage them using `.env` files or server-side configuration tools.

- **File Permissions:**
  - Ensure that the `/var/www/react` directory has the appropriate permissions for the `SERVER_USER` to read and write.

- **Firewall and SSH Access:**
  - Make sure that your server's firewall allows SSH connections on port `22` and that the `SERVER_USER` has the necessary permissions to execute the deployment scripts.

- **Testing Deployment:**
  - After setting up the workflow, perform a test push to the `main` branch to verify that the CI/CD pipeline works as expected and that the deployment occurs successfully.

### **Alternative: Deploying with SCP Instead of SSH Commands**

If you prefer to **copy the built files directly** to your server without executing remote commands, you can use the `appleboy/scp-action`. Here's how to modify the workflow:

1. **Add `SERVER_PASSWORD` to GitHub Secrets** (if not using SSH keys). However, **SSH keys are recommended** for security reasons.

2. **Modify the Deployment Step:**

   ```yaml
   # Deploy to Server via SCP
   - name: Deploy to Server via SCP
     if: github.event_name == 'push'
     uses: appleboy/scp-action@v0.1.3
     with:
       host: ${{ secrets.SERVER_HOST }}
       username: ${{ secrets.SERVER_USER }}
       key: ${{ secrets.SSH_PRIVATE_KEY }}  # Or use 'password: ${{ secrets.SERVER_PASSWORD }}' if using a password
       port: 22
       source: "build/"
       target: "/var/www/react"
   ```

**Note:** Using SCP alone copies the files but doesn't handle tasks like installing dependencies or restarting services. Combining SCP with SSH commands provides a more robust deployment process.

### **Final Thoughts**

By following the above steps and using the provided YAML configuration, you'll have a secure and efficient CI/CD pipeline that builds, tests, and deploys your React application automatically upon changes to the `main` branch.

**Remember:**

- **Never share sensitive information** like passwords publicly.
- **Regularly rotate your SSH keys** and ensure they have the minimal required permissions.
- **Monitor your deployments** to catch and address any issues promptly.

If you encounter any issues or have further questions, feel free to ask!