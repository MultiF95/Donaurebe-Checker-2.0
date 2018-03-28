#!/bin/bash
# DONAUREBE CHECKER 3.0 -- FAVORITES AND NAME FILTER
time=`date +"%H:%M"`

#filter=`sed 's/,/ /g' | sed 's/,//g' | sed 's/RUNACC//g' | sed 's/runacc//g' | sed 's/petacc//g' | sed 's/longruner//g' | sed 's/Petacc//g'| sed 's/Sicai//g' | sed 's/Sable//g'`

create () {
curl -s http://47.91.95.44/index/fc.html > ~/donau/donau_sc.json
curl -s http://47.91.95.44/index/fc.html?page=2 > ~/donau/donau_sc2.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' > ~/donau/donau_lo.txt
jq '.data[] | .listingname' ~/donau/donau_sc2.json | awk -F '"' '{print $2}' > ~/donau/donau_lo2.txt
awk '{print $1, $2, $3, $4, $5}' ~/donau/donau_lo.txt > ~/donau/donau_pl.txt
awk '{print $1, $2, $3, $4, $5}' ~/donau/donau_lo2.txt >> ~/donau/donau_pl.txt
#awk '$0="*"$0' donau_plu.txt > donau_pl.txt
#price###
#########
}

createnow () {
curl -s http://47.91.95.44/index/fc.html > ~/donau/donau_sc.json
curl -s http://47.91.95.44/index/fc.html?page=2 > ~/donau/donau_sc2.json
jq '.data[] | .listingname' ~/donau/donau_sc.json | awk -F '"' '{print $2}' > ~/donau/donau_lo_tmp.txt
jq '.data[] | .listingname' ~/donau/donau_sc2.json | awk -F '"' '{print $2}' > ~/donau/donau_lo2_tmp.txt
awk '{print $1, $2, $3, $4, $5}' ~/donau/donau_lo_tmp.txt > ~/donau/donau_pl_tmp.txt
awk '{print $1, $2, $3, $4, $5}' ~/donau/donau_lo2_tmp.txt >> ~/donau/donau_pl_tmp.txt
#awk '$0="*"$0' donau_plu_tmp.txt > donau_pl_tmp.txt

#price#######
#############
}

createnow

var1=`cat ~/donau/donau_pl.txt`
var2=`cat ~/donau/donau_pl_tmp.txt`

if [ "$var1" != "$var2" ]; then
	echo "check   @ $time"

	diff -u ~/donau/donau_pl.txt ~/donau/donau_pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2 }' | tail -n +2  > ~/donau/changeu.txt
	awk '$0="> "$0' ~/donau/changeu.txt | sed 's/,/ /g' | sed 's/,//g' > ~/donau/change.txt
	 
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
			favlist=`grep "$fav" ~/donau/change.txt`
			if [ ! -z "$favlist" ]; then
				if [ "$favlist" != "$list" ]; then
					curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d channel_tag="donaurebe" -d body="$favlist" -d title="FAVORITE" 'https://api.pushbullet.com/v2/pushes'			
				fi
			fi
			##
		create
		fi

else
	echo "check   @ $time"
fi
