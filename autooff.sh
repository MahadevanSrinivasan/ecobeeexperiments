#!/bin/bash
APIKEY='YOURAPIKEYGOESHERE'
regex='"refresh_token": "(\w+)"'
regex2='"access_token": "(\w+)"'
# Filename where refreshkey needs to be stored (need to create it first time)
File=/home/pi/ecobee/refreshkey.txt 
# Text file containing the POST data for turning off your thermostat
OffJson=/home/pi/ecobee/json.txt

# Read the current refresh token from the file
{
  read REFRESH 
} < $File
# Print the current refresh token
echo "Current refresh token: $REFRESH"

# Get a new token & refresh token
response=`curl -s --request POST --data "grant_type=refresh_token&code=$REFRESH&client_id=$APIKEY" "https://api.ecobee.com/token"`
# echo $response

# Extract the token and the refresh token from JSON
if [[ $response =~ $regex ]]
then
{
	# Save the new refresh token to the file
	echo "${BASH_REMATCH[1]}"
} > $File
else
	echo "Couldn't find the refresh token! Bailing out..."
fi

if [[ $response =~ $regex2 ]]
then
	echo "${BASH_REMATCH[1]}"
	TOKEN=${BASH_REMATCH[1]}
else
	echo "Couldn't find the access token! Bailing out..."
fi

# Turn off the thermostat
curl -s --request POST --data-urlencode "@$OffJson" -H "Content-Type: application/json;charset=UTF-8" -H "Authorization: Bearer $TOKEN" "https://api.ecobee.com/1/thermostat?format=json"
