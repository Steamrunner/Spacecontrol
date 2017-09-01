#!/bin/bash

# script to install the shutdown scripts on a new PC
# to uninstall just run: userdel -r shutdownuser

# install some needed and some usefull stuff
echo "RUNNING APT"
apt --assume-yes install git screen vim whois openssh-server sshpass
echo

echo "CREATING USER"
# generate random password
password=$(date +%s | sha256sum | base64 | head -c 32)
echo "password: $password"

# encode password
encryptedPassword=$(mkpasswd -m sha-512 $password)

# create user
useradd -m -p $encryptedPassword -s /bin/bash shutdownuser

# move to new new users home dir
cd /home/shutdownuser
echo

echo "RUNNING GIT"
# create the git repo, make sure only the right directory 
# is downloaded, and pull in the code
mkdir Spacecontrol
cd Spacecontrol
git init
git remote add -f origin https://github.com/Steamrunner/Spacecontrol.git
git config core.sparseCheckout true
echo poweroff/ > .git/info/sparse-checkout
git pull origin master

# set file owner to the new user
cd ..
chown -R shutdownuser:shutdownuser Spacecontrol

# because I did something wierd with the capital letter...
mv Spacecontrol spacecontrol
echo

echo "RUNNING VISUDO"
# add the right priviliges to sudoers file
echo 'shutdownuser ALL = NOPASSWD: /sbin/shutdown' | sudo EDITOR='tee -a' visudo
echo 'shutdownuser ALL=(ALL:ALL) NOPASSWD:/home/shutdownuser/spacecontrol/poweroff/SC_poweroff_popup.sh' | sudo EDITOR='tee -a' visudo
echo

echo "CONNECTING TO THE SPACECONTROL SERVER"
# ssh to spacecontrol server

sshpass -p unicorns ssh -o StrictHostKeyChecking=no pi@kimball "

touch test

touch test2

"
# copy the key form server to new client
# generate line to be added to openhab config file
