#!/bin/bash

export DISPLAY=:0.0

(
echo "99"; echo "#This system will be shutdown by Spacecontrol in 10 seconds.\nClick cancel to abort."; sleep 1
echo "90"; echo "#This system will be shutdown by Spacecontrol in 9 seconds.\nClick cancel to abort."; sleep 1
echo "80"; echo "#This system will be shutdown by Spacecontrol in 8 seconds.\nClick cancel to abort."; sleep 1
echo "70"; echo "#This system will be shutdown by Spacecontrol in 7 seconds.\nClick cancel to abort."; sleep 1
echo "60"; echo "#This system will be shutdown by Spacecontrol in 6 seconds.\nClick cancel to abort."; sleep 1
echo "50"; echo "#This system will be shutdown by Spacecontrol in 5 seconds.\nClick cancel to abort."; sleep 1
echo "40"; echo "#This system will be shutdown by Spacecontrol in 4 seconds.\nClick cancel to abort."; sleep 1
echo "30"; echo "#This system will be shutdown by Spacecontrol in 3 seconds.\nClick cancel to abort."; sleep 1
echo "20"; echo "#This system will be shutdown by Spacecontrol in 2 seconds.\nClick cancel to abort."; sleep 1
echo "10"; echo "#This system will be shutdown by Spacecontrol in 1 seconds.\nClick cancel to abort."; sleep 1
) |
zenity --progress --title="Spacecontrol Poweroff" --text="This system will be shutdown by Spacecontrol in 10 seconds. \nClick cancel to abort." --percentage=100 --auto-close

