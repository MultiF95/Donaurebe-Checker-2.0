#!/bin/bash
time=`date +"%H:%M"`

create () {
curl -s http://47.91.95.44/index/show.html?page=1 > ~/donau/donau_sc.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' > ~/donau/donau_lo.txt
awk '{print $1, $2, $3, $4}' ~/donau/donau_lo.txt > ~/donau/donau_pl.txt
}

createnow () {
curl -s http://47.91.95.44/index/show.html?page=1 > ~/donau/donau_sc.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' > ~/donau/donau_lo.txt
awk '{print $1, $2, $3, $4}' ~/donau/donau_lo.txt > ~/donau/donau_pl_tmp.txt
}

#main () {

createnow

var1=`cat ~/donau/donau_pl.txt`
var2=`cat ~/donau/donau_pl_tmp.txt`

if [ ! "$var1" == "$var2" ]; then
	
	echo "check   @ $time"
	diff -u ~/donau/donau_pl.txt ~/donau/donau_pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2 }' | tail -n +2  > ~/donau/change.txt
	list=`cat ~/donau/change.txt`
	subject="Neue Produkte auf Donaurebe"
	
		if [ ! -z "$list" ]; then
		
		echo "update  @ $time"
		
		##PUSHBULLET
		{
		curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d channel_tag="donaurebe" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
		} &> /dev/null
		##PUSHBULLET
		
		echo -e "\e[0m$list\e[0m"
		create
		fi

else
	echo "check   @ $time"
fi
#}

#main
#(echo >/dev/tcp/dcdle.net/22) &>/dev/null && echo "main server online. doing nothing" && exit || echo "other checker down. executing..." && main