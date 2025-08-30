
### creating repo folders
``` sh
mkdir -p ~/apps/expressapi/backend/repo
mkdir -p ~/apps/expressapi/backend/dest
```

### create central repo
go to folder and init git

``` sh
cd ~/apps/expressapi/backend/repo
git --bare init
```

### open hooks folder
``` sh
nano hooks/post-receive
```

``` sh
#!/bin/bash -l
echo 'post-receive: Triggered.'
cd ~/apps/expressapi/backend/dest/
echo 'post-receive: git check out...'
git --git-dir=/root/apps/expressapi/backend/repo/ --work-tree=/root/apps/expressapi/backend/dest/ checkout main -f
echo 'post-receive: npm install...'
npm install
npm run build
forever restart expressapi
```

### change permission
``` sh
chmod ug+x hooks/post-receive
```

## create .env
your uploaded file will be in dest folder

``` sh
cd ../dest
nano .env
```

# install forever
``` sh
sudo npm install forever -g
```

## add repo to remote server
Here i am using hostinger vps server
``` sh
git remote add hostinger ssh://root@your-server-ip-address/root/apps/expressapi/backend/repo/
```

### push 
``` sh
git add . && git commit -m "initial uploads" && git push hostinger main
```

### then finally
``` sh
forever start --uid="expressapi" --sourceDir="/root/apps/expressapi/backend/dest/" backend/server.js
```
