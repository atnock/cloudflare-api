#!/bin/bash

# set your user, token (key) name server and a comma-separated list of A records you want to change
CFU="my@email.com"
CFP="mytoken"
CFNS="My Nameservers"
CFHOST="example.com"
CFNAME="sub.example.com"
CFID="mydomainid"

# get your current external ip address
CFIP=$(curl -s "http://myip.dnsomatic.com/")

# build the url you need to do the update
CFURL="https://www.cloudflare.com/api_json.html?a=rec_edit&tkn=$CFP&id=$CFID&email=$CFU&z=$CFHOST&type=A&name=$CFNAME&content=$CFIP&service_mode=0&ttl=1"

# find out the ip address listed in DNS for the first host in your list
CFHOSTIP=$(nslookup $(echo $CFHOST | cut -d ',' -f1) $CFNS | grep Address: | tail -1 | cut -d ' ' -f2)

# if your current external IP are different from what shows in DNS do the update
if [ "$CFIP" != "$CFHOSTIP" ]
then
     # use curl to do the dynamic update
      /usr/bin/curl -k $CFURL
else
	echo "IP already ok !"
fi

# uncomment to know your id
#/usr/bin/curl -vk  "https://www.cloudflare.com/api_json.html?a=rec_load_all&tkn=$CFP&z=$CFHOST&email=$CFU"
