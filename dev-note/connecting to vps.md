### Connection to vps

simply add command

```sh
ssh root@your-serverip
```
it will ask for pawssword

after enterning passsword you are ready to go


### If you want to connect without password 

got to your device root and get your device ssh key

```sh
cd ./ssh
cat id_rsa.pub
```
then copy your ssh_key 
go to your vps server provider profile
then you need to find an option in setting section which is called "add ssh key" then past there 


and then run this command in your terminal

```sh
ssh-keygen -R [SERVER_IP_ADDRESS]
```

i got solution from here
```sh
https://stackoverflow.com/questions/20840012/ssh-remote-host-identification-has-changed
```