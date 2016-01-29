#!/bin/bash

export DISPLAY=:0.0
xhost local:$1

(
echo "99"; echo "#This system will be shutdown by Spacecontrol in 20 seconds.\nClick cancel to abort."; sleep 1
echo "95"; echo "#This system will be shutdown by Spacecontrol in 19 seconds.\nClick cancel to abort."; sleep 1
echo "90"; echo "#This system will be shutdown by Spacecontrol in 18 seconds.\nClick cancel to abort."; sleep 1
echo "85"; echo "#This system will be shutdown by Spacecontrol in 17 seconds.\nClick cancel to abort."; sleep 1
echo "80"; echo "#This system will be shutdown by Spacecontrol in 16 seconds.\nClick cancel to abort."; sleep 1
echo "75"; echo "#This system will be shutdown by Spacecontrol in 15 seconds.\nClick cancel to abort."; sleep 1
echo "70"; echo "#This system will be shutdown by Spacecontrol in 14 seconds.\nClick cancel to abort."; sleep 1
echo "65"; echo "#This system will be shutdown by Spacecontrol in 13 seconds.\nClick cancel to abort."; sleep 1
echo "60"; echo "#This system will be shutdown by Spacecontrol in 12 seconds.\nClick cancel to abort."; sleep 1
echo "55"; echo "#This system will be shutdown by Spacecontrol in 11 seconds.\nClick cancel to abort."; sleep 1
echo "50"; echo "#This system will be shutdown by Spacecontrol in 10 seconds.\nClick cancel to abort."; sleep 1
echo "45"; echo "#This system will be shutdown by Spacecontrol in 9 seconds.\nClick cancel to abort."; sleep 1
echo "40"; echo "#This system will be shutdown by Spacecontrol in 8 seconds.\nClick cancel to abort."; sleep 1
echo "35"; echo "#This system will be shutdown by Spacecontrol in 7 seconds.\nClick cancel to abort."; sleep 1
echo "30"; echo "#This system will be shutdown by Spacecontrol in 6 seconds.\nClick cancel to abort."; sleep 1
echo "25"; echo "#This system will be shutdown by Spacecontrol in 5 seconds.\nClick cancel to abort."; sleep 1
echo "20"; echo "#This system will be shutdown by Spacecontrol in 4 seconds.\nClick cancel to abort."; sleep 1
echo "15"; echo "#This system will be shutdown by Spacecontrol in 3 seconds.\nClick cancel to abort."; sleep 1
echo "10"; echo "#This system will be shutdown by Spacecontrol in 2 seconds.\nClick cancel to abort."; sleep 1
echo "5"; echo "#This system will be shutdown by Spacecontrol in 1 seconds.\nClick cancel to abort."; sleep 1
) | zenity --progress --title="Spacecontrol Poweroff" --text="The Space and this system will be shutdown by Spacecontrol in 20 seconds. \nClick cancel to abort shutdown." --percentage=100 --auto-close

