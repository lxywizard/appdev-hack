# freefood
An IOS app that can get the information of surrounding events that offer freefood through facebook public events at Cornell.

## Description
freefood is an app that can be used to find the nearing events that offer freefood at Cornell. The user can just launch the app and see what events at Cornell offer free food, and they can choose to only display the events at a certain part of the campus, like only the north campus or central campus; they can also filter the events by dates for about one week's range. Users can click into the event to check the details and see the location of the event in Map. They can mark the events they like as favourites and check them anytime later. In the future, this app will support the features of getting events with free food in a bigger region or maybe anywhere in the world.

## Backend
We implemented a login system that allows user to store and delete their favorite events using session login (IOS team didn't have time to integrate that in their client). We also provided the functionality to store, get, and delete the events that contain free food to our database. We get rejected when requesting facebook public data access so we are unable to fetch facebook data. Currently the events are hard-coded to the server (use the developer's user accesstoken to get the information of the events that the developer's facebook account is participating through Facebook Graph API and post them to our database). However, the code for requesting facebook event will still be in the resipotory, [facebook_bot.py](https://github.com/tudoanh/python-facebook-bot) (get the nearby events) (Credit: tudoanh) and helpers.py (filter the events that do not contain free food).

There are two possible approaches we have thought about to get the events but they all require the [extra permissions](https://developers.facebook.com/docs/apps/review) from Facebook:
-  Use the facebook_bot to directly get the nearby events and push them to the user's events table if we have the Page Public Content Access
- Let the user sign in through facebook, and we can get their user accesstokens. With their accesstokens and facebook's permission, we can directly push the events that they are interested in to the database through Facebook Graph API (with their permissions). This is what we are doing now with my developer account as without App Review, only the developer account has the permission. With more and more people using the app, we can get most of the popular events that contain free food in a certain region. This way could potentially work well in a certain area with a limited amount of events (which is Cornell). 

The backend part is implemented by flask and hosted on google cloud (**IP address: 35.227.40.205**).

## IOS
Our MainViewController consists of a searchBar, UILabel, and UICollectionView. The searchBar searches for events by their titles, and in the collectionView, each cell consists of an event. 

<img src="https://raw.githubusercontent.com/lxywizard/freefood/master/images/1.png" width = "325" height = "650" alt="Image1" align=center />

The rightBarButtonItem “Filter” pushes a filterViewController, and it contains filters for date and location. We could only pick one date, but multiple location filters could be selected.

<img src="https://raw.githubusercontent.com/lxywizard/freefood/master/images/2.png" width = "325" height = "650" alt="Image2" align=center />

If we click an event cell, it will push a detailViewController, which contains the image of the event and its details.

<img src="https://raw.githubusercontent.com/lxywizard/freefood/master/images/3.png" width = "325" height = "650" alt="Image3" align=center />

If we click the leftBarButtonItem “Map” in the mainViewController, then it will push a map, with markers on all the events’ locations.

<img src="https://raw.githubusercontent.com/lxywizard/freefood/master/images/4.png" width = "325" height = "650" alt="Image4" align=center />

If we click a marker, it will push to the detailViewController of this event.

<img src="https://raw.githubusercontent.com/lxywizard/freefood/master/images/5.png" width = "325" height = "650" alt="Image5" align=center />

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
