#!/bin/bash
#Rebechecker v4.1, Date: 03.04.2018
time=`date +"%H:%M"`

#parameters:
domain="47.91.95.44"
tag="" 				#pushbullet channel name
min="50"						#minimum price to trigger expensive push
path="/Users/xxx/xxx" 	#folder for temp files. Favour RAM Storage for 24/7 use
endpage="3"			 			#json sites will be checked. Example: 03.04.2018 2 - 3 pages

create () {
rm $path/plu$state.txt
for (( page = 1; page <= $endpage; page++ ))
do
	echo downloading page $page json
	curl -s http://$domain/index/fc.html?page=$page > $path/source$page.json
	jq '.data[] | "\(.listingname) \(.price)"' $path/source$page.json | awk -F '"' '{print $2}' >> $path/plu$state.txt
	sleep 1.5
done
#price
echo downloading price json
curl -s http://$domain/index/fc.html?cond=price > $path/sourcep.json
sleep 1.5
jq '.data[] | "\(.listingname) \(.price)"' $path/sourcep.json | awk -F '"' '{print $2}' >> $path/plu$state.txt
jq '.data[] | "\(.listingname) \(.price)"' $path/sourcep.json | awk -F '"' '{print $2}' | head -n 1| awk '{print $NF}' | awk -F "." '{print $1}' > $path/price$state.txt
sort -u $path/plu$state.txt | awk '{print ">",$1, $2, $3, $4, $5, "||", $NF,"€"}' | sed 's/,//g' > $path/pl$state.txt
}

state="_tmp"
create

pl=`cat $path/pl.txt`
plt=`cat $path/pl_tmp.txt`

if [ "$pl" != "$plt" ]; then
		
		##LIST UPDATE
		echo "productlist update"
		diff -u $path/pl.txt $path/pl_tmp.txt | grep '^+' | awk -F'+' '{ print $2 }' | tail -n +2 > $path/change.txt
		list=`cat $path/change.txt`
		
		##TRIGGER IF UPDATE NOT NULL
		if [ ! -z "$list" ]; then
		echo "changes checked and set"
		
		##PRICE CHECK
		p=`cat $path/price.txt`
		ptmp=`cat $path/price_tmp.txt`
		
			if [ "$ptmp" -ge "$min" -a "$ptmp" -ne "$p" ]; then
				id=`cat $path/sourcep.json | awk -F '"' '{print $10}'`
				link=`echo http://$domain/index/product.html?orderid=$id`
				na=`jq '.data[] | "\(.listingname) \(.price)"' $path/sourcep.json | awk -F '"' '{print $2}' | head -n 1| awk '{print $1, $2, $3, $4, $5}'`
				pricetitle=`echo "EXPENSIVE "$na $ptmp "€"`
				{
				curl -s -u """>apikeyhere<"":" -d type="note" -d channel_tag="$tag" -d body="$link" -d title="$pricetitle" 'https://api.pushbullet.com/v2/pushes' 
				} &> /dev/null
				echo $ptmp > $path/price.txt
			fi

		##PUSH
		{
		curl -s -u """>apikeyhere<"":" -d type="note" -d channel_tag="$tag" -d body="$list" -d title="NEW" 'https://api.pushbullet.com/v2/pushes'
		} &> /dev/null

		##ECHO
		echo "updates:"
		echo "$list"

		##FAVORITES
		fav=`cat favorites.txt`
		favlist=`grep "$fav" $path/change.txt`
		if [ ! -z "$favlist" ]; then
			if [ "$favlist" != "$list" ]; then
			curl -s -u """>apikeyhere<"":" -d type="note" -d channel_tag="$tag" -d body="$favlist" -d title="FAVORITE" 'https://api.pushbullet.com/v2/pushes'			
			fi
		fi

		##CREATE
		state=""
		create

		fi
else

	echo "no update"

fi
