#!/bin/bash

resize -s 25 25

ver=2.0.0

#CHECKS DATA
clear
echo "DATA CHECK: "
sleep 1
if [ ! -d ~/donau ]; then
	clear
	echo -e "DATA CHECK: ERROR"
	sleep 1
	echo "CREATING MISSING FILES / DIRS"
	sudo apt-get install curl
	mkdir ~/donau
	chmod 777 ~/donau_main.sh
	sleep 1
	clear
	echo -e "FINISHED"
	sleep 3
	./donau.sh

else
	clear
	echo -e "\e[42mDATA CHECK: OK\e[0m"
	sleep 1	
fi

#MAIN
clear
echo "DONAUREBE CHECKER"
echo "VERSION: $ver"
echo "Cntrl + C to exit"
echo "-----------------------------"
echo ""
echo "Enter Refresh Rate"
echo "60sec = 1min, 300sec = 5mins,"
echo "600sec = 10mins"
echo ""
echo "-----------------------------"
read sec
clear
echo "DONAUREBE CHECKER IS RUNNING"
echo "VERSION: $ver"
echo "Cntrl + C to exit"
echo "-----------------------------"
while true ; do /home/$USER/donau_main.sh & sleep $sec; done
