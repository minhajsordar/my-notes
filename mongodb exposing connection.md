The `not authorized on express to execute command { dbStats: 1 }` error suggests that the `minhaj` user doesn’t have sufficient permissions to perform database administrative tasks like retrieving statistics. While the `readWrite` role allows basic read and write operations, administrative commands like `db.stats()` require additional privileges.

To resolve this, you can grant the `dbAdmin` role to the `minhaj` user on the `express` database. This will provide permissions to run commands like `db.stats()`.

### Steps to Add the `dbAdmin` Role to the User

1. **Log in as an Admin User:**
   Use an admin account to log in to MongoDB. For example:
   ```bash
   mongo -u adminUsername -p adminPassword --authenticationDatabase admin
   ```

2. **Switch to the `express` Database:**
   ```javascript
   use express
   ```

3. **Grant `dbAdmin` Role to `minhaj`:**
   Run the following command to add the `dbAdmin` role to the `minhaj` user on the `express` database:
   ```javascript
   db.updateUser("minhaj", {
     roles: [
       { role: "readWrite", db: "express" },
       { role: "dbAdmin", db: "express" }
     ]
   })
   ```

4. **Log in with the Updated User Permissions:**
   Log out and then log back in with the `minhaj` user:
   ```bash
   mongo -u minhaj -p MinshajS0rdeedsxr --authenticationDatabase express
   ```

5. **Test the `db.stats()` Command:**
   Now, run `db.stats()` to confirm that the `minhaj` user has the necessary permissions.

By adding the `dbAdmin` role, the `minhaj` user should be able to execute `db.stats()` and other database administrative commands on the `express` database. Let me know if you encounter any further issues!