#!/bin/bash

# install some needed and some usefull stuff
apt install git screen vim whois

# generate random password
password=$(date +%s | sha256sum | base64 | head -c 32)
echo $password

# encode password
encryptedPassword=$(mkpasswd -m sha-512 $password)
echo "------------------------------------"
echo $encryptedPassword
echo "------------------------------------"



# create user
useradd -m -p $encryptedPassword -s /bin/bash shutdownuser

exit 0

# 
cd /home/shutdownuser
git clone 
# user priviliges???

# ssh to spacecontrol server

# copy the key form server to new client
# generate line to be added to openhab config file
