# Ecobee Experiments
I got a free ecobee thermostat from my utility company. It was a big step forward from my older analog Honeywell thermostat. For one I could use an iPhone app to control the thermostat. Their App is great and all. But, I need to click through 5 different buttons to turn off my thermostat. I got lazy and so I got inspired. I went and looked into their developer API which turned out to be a pretty good reference. Best place to start is their [examples page](https://www.ecobee.com/home/developer/api/examples/index.shtml).

## Honey, look! Our thermostat turned itself off at 8 AM!

I had a Raspberry Pi sitting idly connected to my internet. And it runs Linux so it already has cron on it. Why not use it? So, I dug through their documentation and came up with a quick and dirty bash script which when executed turns off my thermostat. At this point, I don't have a lot of error checking. But, hey, this is Github. Go ahead, make my day.

## Keys, Tokens and Autorunning Thermostats

Get your API key by following the instructions on the [ecobee developer page](https://www.ecobee.com/home/developer/api/examples/ex1.shtml). Use that API key to get a PIN & an authorization code. Use the pin and go activate your application. Next, use the API key and the authorization code to get your first set of "Access token" and "Refresh token". These two are very important. For security reasons, your access token is valid only for 60 minutes. To get a new "Access token", you need to use the API key and the previous *refresh token*. Doing so will give you another set of *access token* and *refresh token*. That is pretty much all. You can use the access token to turn off your thermostat. To recap:

- Create application and get API key
- Obtain Pin and Authorization code
- Activate App using the Pin
- Use API key and Activation code to get access and refresh tokens
- Begin automating things

## Setting up the script

Get all the files from the Github repository. Follow the steps below:
- Put your API key on line 2
- Change the refreshkey.txt path on line 6 to point to your local file.
- Change the json.txt path on line 8 to point to your local file.
- Make sure you use **full absolute** paths for both files.
- Modify the refreshkey.txt contents with your "Refresh token".
- Do `chmod 700 autooff.sh`
- Turn your ecobee thermostat on and then do `.\autooff.sh` from your terminal.
- Magic!

## Adding your script to cron

This step is quite simple if you are on a Linux box (should work on Macs too). Make a note of your `autooff.sh` script's full path. In my example, it is `/home/pi/ecobee/test.sh`. Do `crontab -e`. Add the following line to your crontab. Remember that there are tabs between the fields. For a quick overview of crontab fields, have a look at [this article](http://www.thegeekstuff.com/2009/06/15-practical-crontab-examples/).

``
00      08      *       *       *       /home/pi/ecobee/test.sh
``

With the above setting in my crontab, my thermostat is turned off every morning (all days of the week) at 08:00 AM. Side note: Make sure the linux box has the correct timezone setting. Otherwise, you might need to modify the script to account for the system time. Use the `date` command to check the current time.
