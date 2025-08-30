#!/bin/bash

# Variables
MONGO_USER="your_username"       # Current admin username
MONGO_PASS="your_password"       # Current admin password
MONGO_HOST="your_host"           # e.g., 142.93.236.178
MONGO_PORT="27017"
NEW_ADMIN_USER="adminUser"       # New admin username
NEW_ADMIN_PASS="adminPassword"    # New admin password

# Log in to MongoDB and run commands
mongo --host $MONGO_HOST --port $MONGO_PORT -u $MONGO_USER -p $MONGO_PASS --authenticationDatabase admin <<EOF
use admin

// Check if the user already exists
if (!db.getUsers().some(user => user.user === "$NEW_ADMIN_USER")) {
    // Create the new admin user
    db.createUser({
        user: "$NEW_ADMIN_USER",
        pwd: "$NEW_ADMIN_PASS",
        roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
    });
    print("Admin user created successfully: $NEW_ADMIN_USER");
} else {
    print("Admin user already exists: $NEW_ADMIN_USER");
}

// Show collections
show collections
EOF
