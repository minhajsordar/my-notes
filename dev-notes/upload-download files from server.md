# Detail information here
https://www.hypexr.org/linux_scp_help.php

## Download whole folder from remote server to local system 
``` sh
scp -r username@ip-address:~/directorypath /Users/username/etc...
```

## Upload whole folder to remote server from local system 
``` sh
scp -r /Users/username/etc... username@ip-address:~/directorypath 
```

## Download file from remote server to local system 
``` sh
scp username@ip-address:~/directorypath/filename.ext /Users/username/etc...
```

## Upload file to remote server from local
``` sh
scp /Users/username/filename.ext username@ip-address:~/directorypath
```