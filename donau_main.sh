#!/bin/bash
# DONAUREBE CHECKER 3.0 -- FAVORITES AND NAME FILTER
time=`date +"%H:%M"`

#filter=`sed 's/,/ /g' | sed 's/,//g' | sed 's/RUNACC//g' | sed 's/runacc//g' | sed 's/petacc//g' | sed 's/longruner//g' | sed 's/Petacc//g'| sed 's/Sicai//g' | sed 's/Sable//g'`

create () {
curl -s http://47.91.95.44/index/show.html?page=1 > ~/donau/donau_sc.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' | sed 's/,/ /g' | sed 's/,//g' > ~/donau/donau_lo.txt
awk '{print $1, $2, $3, $4, $5}' ~/donau/donau_lo.txt > ~/donau/donau_pl.txt
}

createnow () {
curl -s http://47.91.95.44/index/show.html?page=1 > ~/donau/donau_sc.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' | sed 's/,/ /g' | sed 's/,//g' > ~/donau/donau_lo.txt
awk '{print $1, $2, $3, $4, $5}' ~/donau/donau_lo.txt > ~/donau/donau_pl_tmp.txt
}

createnow

var1=`cat ~/donau/donau_pl.txt`
var2=`cat ~/donau/donau_pl_tmp.txt`

if [ ! "$var1" == "$var2" ]; then
	echo "check   @ $time"

	diff -u ~/donau/donau_pl.txt ~/donau/donau_pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2 }' | tail -n +2  > ~/donau/change.txt
	 
	list=`cat ~/donau/change.txt`
	subject="NEW"
	
		if [ ! -z "$list" ]; then
		
		echo "update  @ $time"
		
		##osascript -e 'display notification "$list" with title "DonaurebeChecker"'
		##PUSHBULLET
		{
		curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d channel_tag="donaurebe" -d body="$list" -d title="$subject" 'https://api.pushbullet.com/v2/pushes'
		} &> /dev/null
		##PUSHBULLET
		
		echo -e "\e[0m$list\e[0m"
		
			## Favorite
			fav=`cat ~/donau/favorites.txt`
			favlist=`grep "$fav" change.txt`
			if [ ! -z "$favlist" ]; then
				if [ ! "$favlist" == "$list" ]; then
					curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d channel_tag="donaurebe" -d body="$favlist" -d title="FAVORITE" 'https://api.pushbullet.com/v2/pushes'			
				fi
			fi
			##
		create
		fi

else
	echo "check   @ $time"
fi
