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
	#diff -u ~/donau/donau_pl.txt ~/donau/donau_pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2, $3, $6, $7, $8 }' > ~/donau/change.txt
	diff -u ~/donau/donau_pl.txt ~/donau/donau_pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2 }' | tail -n +2  > ~/donau/change.txt
	list=`cat ~/donau/change.txt`
	subject="Neue Produkte auf Donaurebe"
	
	##PUSHBULLET
	curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
	curl -s -u """o.oULkayHrtUOyvLNgRWlLlApWDJ7dqWoR"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
	curl -s -u """o.zHAKXyNMBlZCZrFwlfr6LCWfxhA2WNkd"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
	curl -s -u """o.dFbrxftwLFO7N9UUEIPrj5Fbq0IZiiZp"":" -d type="note" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'

	echo $list
	create

else

	echo "check @ $time"

fi
