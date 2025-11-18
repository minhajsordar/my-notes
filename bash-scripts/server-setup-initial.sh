#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt install git
sudo apt-get install curl

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install nodejs
sudo bash /tmp/nodesource_setup.sh