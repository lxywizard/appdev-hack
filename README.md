# freefood
An IOS app that can get the information of surrounding events that offer freefood through facebook public events.

## Description

## Backend
We implemented a login system that allows user to store and delete their favorite events using session login (IOS team didn'e have time to integrate that in their client). We also provided the functionality to store, get, and delete the events that contain free food to our database. We get rejected when requesting facebook public data access so we are unable to fetch facebook data. Currently the events are hard-coded to the server (use the developer's user accesstoken to get the information of the events that the developer's facebook account is participating through Facebook Graph API and post them to our database). However, the code for requesting facebook event will still be in the resipotory, [facebook_bot.py](https://github.com/tudoanh/python-facebook-bot) (get the nearby events) (Credit: tudoanh) and helpers.py (filter the events that do not contain free food).

There are two possible approaches we have thought about to get the events but they all require the [extra permissions](https://developers.facebook.com/docs/apps/review) from Facebook:
-  Use the facebook_bot to directly get the nearby events and push them to the user's events table if we have the Page Public Content Access
- Let the user sign in, and we can get their user accesstokens. With their accesstokens and facebook's permission, we can directly push their the events they are interested in to the database through Facebook Graph API (with their permissions). This is what we are doing now with my developer account as without App Review, only the developer account has the permission. This way could only be applied to a certain area with a certain amount of events (like Cornell). 

The backend part is implemented by flask and hosted on google cloud (**IP address: 35.227.40.205**).

## Backend Setup
These are the commands to run to configure your development machine before starting the backend code **locally**.

```shell
sudo pip3 install virtualenv
cd Backend/src
virtualenv venv
. venv/bin/activate
pip3 install -r requirements.txt
```

To start the server

```shell
cd Backend/src
python3 routes.py
```
