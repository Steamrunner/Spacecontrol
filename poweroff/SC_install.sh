#!/usr/bin/env bash

# script to install the shutdown scripts on a new PC
# to uninstall just run: userdel -r shutdownuser and
# remove the added lines form the sudoers file (using
# visudo)

# install some needed and some usefull stuff
echo "RUNNING APT"
apt --assume-yes install git screen vim whois openssh-server sshpass net-tools
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

# make sure new user isn't shown on login screen
echo -e "[User]\nSystemAccount=true" > /var/lib/AccountsService/users/shutdownuser
echo

echo "RUNNING GIT"
# create the git repo, make sure only the right directory 
# is downloaded, and pull in the code
mkdir spacecontrol
cd spacecontrol
git init
git remote add -f origin https://github.com/Steamrunner/Spacecontrol.git
git config core.sparseCheckout true
echo poweroff/ > .git/info/sparse-checkout
git pull origin master

# set file owner to the new user
cd ..
chown -R shutdownuser:shutdownuser spacecontrol
echo

echo "RUNNING VISUDO"
# add the right priviliges to sudoers file
echo 'shutdownuser ALL = NOPASSWD: /sbin/shutdown' | sudo EDITOR='tee -a' visudo
echo 'shutdownuser ALL = NOPASSWD: /bin/systemctl' | sudo EDITOR='tee -a' visudo
echo 'shutdownuser ALL=(ALL:ALL) NOPASSWD:/home/shutdownuser/spacecontrol/poweroff/SC_poweroff_popup.sh' | sudo EDITOR='tee -a' visudo
echo

# get local ip
ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo "this machines IP: $ip"
hostname=`cat /etc/hostname`
echo "this machines hostname: $hostname"
echo 

echo "CONNECTING TO THE SPACECONTROL SERVER"
# ssh to spacecontrol server

# copy the key form server to new client
sshpass -p unicorns ssh -o StrictHostKeyChecking=no pi@kimball "
sudo -u openhab sshpass -p $password ssh-copy-id -o StrictHostKeyChecking=no shutdownuser@$hostname
"
#sudo -u openhab sshpass -p $password ssh -o StrictHostKeyChecking=no shutdownuser@$ip exit

echo "CONNECTING TO THE UNIPI SERVER"
# ssh to unipi server

# copy the key form server to new client
sshpass -p raspberry ssh -o StrictHostKeyChecking=no pi@unipi "
sudo -u openhab sshpass -p $password ssh-copy-id -o StrictHostKeyChecking=no shutdownuser@$hostname
"
#sudo -u openhab sshpass -p $password ssh -o StrictHostKeyChecking=no shutdownuser@$ip exit

# generate line to be added to openhab & unipi config file

