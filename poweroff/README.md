# Installation #

To install the small spacecontrol shutdown script on a new PC please run: 

`wget -q https://raw.githubusercontent.com/Steamrunner/Spacecontrol/master/poweroff/SC_install.sh -O - | sudo sh`

Tested on ubuntu 14.04, 16.04 and 18.04.

This script creates the "shutdownuser" on the client machine, adds the necessary rules to the sudoers file, downloads the script itself to the and installs ssh keys on unipi and kimball. After this script is run on a new client modify the openhab configuration on unipi and kimball to include the new machine. This should be completely analogous to the other machines already in the system.

