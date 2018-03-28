#!/bin/bash
create () {
	rm ~/donau/donau_sc_price.json
	json=`curl -s http://47.91.95.44/index/fc.html?cond=price&ca=&page=1`
	echo $json > ~/donau/donau_sc_price.json
	price=`cat ~/donau/donau_sc_price.json | awk -F '"' '{print $14}' | awk -F '.' '{ print $1 }'` 
	echo $price > ~/donau/price
}
createnow () {
	rm ~/donau/donau_sc_price.json
	json=`curl -s http://47.91.95.44/index/fc.html?cond=price&ca=&page=1`
	echo $json > ~/donau/donau_sc_price.json
	price2=`cat ~/donau/donau_sc_price.json | awk -F '"' '{print $14}' | awk -F '.' '{ print $1 }'`
	name=`cat ~/donau/donau_sc_price.json | awk -F '"listingname":"' '{print $2}' | awk -F ' ' '{print $1, $2, $3, $4}'`
	id=`cat ~/donau/donau_sc_price.json | awk -F '"' '{print $10}'`

}
createnow
link="http://47.91.95.44/index/product.html?orderid=$id"
body="$name für "$price2"€                                          "$link""
bodysp=`echo "> "$body | ascii2uni -a U -q`
#bodysp=`echo "> "$body | grep '^+' | awk -F '+' '{ print $2 }' | tail -n +2`
price=`cat ~/donau/price`
echo $price
echo $price2
echo $body


if [ "$price" != "$price2" ]; then 
	echo "new"
	echo $price
	echo $price2
	create
		if [ $price2 -ge 45 ]; then
		echo "greater than 45€!"
		#{ curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d body="$body" -d title="EXPENSIVE" 'https://api.pushbullet.com/v2/pushes'
		#} &> /dev/null	
		#sleep 20
	    	curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d channel_tag="donaurebe" -d body="$bodysp" -d title="EXPENSIVE" 'https://api.pushbullet.com/v2/pushes'
		#curl -s -u """o.l01W0uErXooJuf0DZhHXsHXlXnij9oEr"":" -d type="note" -d channel_tag="donaurebe" -d body="$link" -d title="" 'https://api.pushbullet.com/v2/pushes'
	    	create
		fi
    else
	echo "nn"
fi
