https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-ubuntu/
### Platform Support
24.04 LTS ("Noble")

22.04 LTS ("Jammy")

20.04 LTS ("Focal")

```
cat /etc/lsb-release
```

```
sudo apt-get install gnupg curl
```
```
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor
```
#### ubuntu 24.04
```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```
#### ubuntu 22.04
```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```
#### ubuntu 20.04
```
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```
# install mongodb
sudo apt-get install -y mongodb-org
### release update
```
sudo apt-get update
```
### release update
```
ps --no-headers -o comm 1
```
```
sudo systemctl start mongod
```
```
sudo systemctl daemon-reload
```
```
sudo systemctl status mongod
```
```
sudo systemctl enable mongod

```
```
sudo systemctl stop mongod


```
```
sudo systemctl restart mongod

```

db.createUser({
  user: "admin",
  pwd: "MinhajS0rder",
  roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
})
db.createUser({
  user: "minhaj",
  pwd: "MinhajS0rder",
  roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
})
db.createUser({
  user: "dbusername",
  pwd: "dbpassword",
  roles: [
    { role: "readWrite", db: "dbname" },
    { role: "dbAdmin", db: "dbname" }
    ]
})

db.updateUser("dbusername", {
  roles: [
    { role: "readWrite", db: "dbname" },
    { role: "dbAdmin", db: "dbname" }
  ]
})


mongo -u admin -p Minh@jS0rder --authenticationDatabase admin

