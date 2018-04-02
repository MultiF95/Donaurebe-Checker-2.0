# Rebechecker for Linux or OSX

## Description

The Rebechecker checks products on xxxrebe.com and sends newly listed items to a Pushbullet Channel.

## Features

Create a Favorites-List to get a dedicated "FAVORITE" Push to the Pushbullet Channel.

Set a minumum price of a product to get notified about expensive products seperately.

## Installation

- move "rebecheck.sh" to your wished directory.

- create a temp file folder and set the path in the script.

- make executeable. (chmod +x rebecheck.sh)

- run the script once

- create missing files and install the missing programs ( jq f.e. )

- create a crontab that executes script every x minutes

Tested with Ubuntu 17.10, RASPBIAN, and OSX High Sierra

## Parameters

"domain": the current domain of xxrebe
"tag": the pushbulletchannel tag to push to
"path": temp files will be stored there
"endpage": tell the script how many json pages to check 
