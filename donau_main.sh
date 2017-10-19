#!/bin/bash

time=`date +"%H:%M"`

create () {
curl -s http://47.91.95.44/index/show.html?page=1 > ~/donau/donau_sc.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' > ~/donau/donau_lo.txt
awk -F '\ ' '{print $1, $2, $3, $4}' ~/donau/donau_lo.txt > ~/donau/donau_pl.txt
}

createnow () {
curl -s http://47.91.95.44/index/show.html?page=1 > ~/donau/donau_sc.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' > ~/donau/donau_lo.txt
awk -F '\ ' '{print $1, $2, $3, $4}' ~/donau/donau_lo.txt > ~/donau/donau_pl_tmp.txt
}

createnow

var1=`cat ~/donau/donau_pl.txt`
var2=`cat ~/donau/donau_pl_tmp.txt`

if [ ! "$var1" == "$var2" ]; then
	
	echo "update @ $time"
	notify-send "NEW PRODUCTS @ DONAUREBE"
	diff -u ~/donau/donau_pl.txt ~/donau/donau_pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2, $3, $4 }' > ~/donau/change.txt
	
	list=`cat ~/donau/change.txt`
	subject="Neue Produkte auf Donaurebe"
	
	##PUSHBULLET
	curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
	curl -s -u """o.oULkayHrtUOyvLNgRWlLlApWDJ7dqWoR"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
	#curl -s -u """YYY"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
	#curl -s -u """YYY"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'

	echo $list
	rm ~/donau/donau_pl_tmp.txt
	create

else

	echo "check @ $time"
	rm ~/donau/donau_pl_tmp.txt

fi
