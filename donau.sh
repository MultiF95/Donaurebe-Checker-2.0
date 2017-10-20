#!/bin/bash
ver=2.2

#data check
clear
echo "DATA CHECK: "
sleep 1
if [ ! -d ~/donau ]; then
	clear
	echo -e "DATA CHECK: ERROR"
	sleep 1
	sudo apt-get install curl
	sudo apt-get install jq
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
	sleep .5	
fi

#main
clear
echo "DONAUREBE CHECKER IS RUNNING"
echo "VERSION: $ver"
echo "Cntrl + C to exit"
echo "-----------------------------"
while true ; do /home/$USER/donau_main.sh & sleep 60; done
