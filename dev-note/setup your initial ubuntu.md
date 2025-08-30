# Update ubuntu 22.04
``` sh
sudo apt-get update
sudo apt-get upgrade
sudo apt install git
sudo apt-get install curl
```

## install nodejs.
``` sh
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
```

``` sh
sudo apt-get install nodejs
```

``` sh
sudo bash /tmp/nodesource_setup.sh
```

## install denojs
``` sh
curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL=/usr/local sh
```

## install rust
``` sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env 
```
