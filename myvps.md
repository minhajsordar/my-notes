# MinhajSorder vps 
ssh root@212.85.24.184
pass Minh@jS0rder8765

# MinhajSorder vps  new
ssh root@72.61.119.179
pass Minh@jS0rder8765

dbOperationScript
mongodb user root
mongodbpass Minh@jS0rder8765
~/actions-runner/expressapigen/api-builder-express/api-builder-express

# before runner add this to get jsolved
RUNNER_ALLOW_RUNASROOT=true

RUNNER_ALLOW_RUNASROOT=true ./config.sh --url https://github.com/minhaj57sorder/api-builder-express --token ARYEF6LAB6YHXWGQTJZLF4LFLMFFC

./svc.sh

 rsync -avzP -e "ssh -p 2222" user@212.85.24.184:/etc/apache2/ ~/Downloads/etc/apache2/

Solution: 
ssh-keygen -R 212.85.24.184

Problem: for this warning we need to re generate ssh key
minhaj@minhajs-MacBook-Air mern server setup % ssh root@212.85.24.184
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:YDLafE37yUTPxyIYyrvbfY7Kl6isc2CoyWvPZ0Vh71M.
Please contact your system administrator.
Add correct host key in /Users/minhaj/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/minhaj/.ssh/known_hosts:16
Host key for 212.85.24.184 has changed and you have requested strict checking.
Host key verification failed.

