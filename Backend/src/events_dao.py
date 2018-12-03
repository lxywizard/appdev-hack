import facebook_bot as fb
from db import db, User, Event

def get_event_by_id(id_num):
    return Event.query.filter(Event.id == id_num).first()

def filter_event_for_food(event)
    content = event["content"]
    index = content.find('free food')
    if not (index == -1):
        return True
    else return false.

def fetch_events_from_fb()
    longitude = -76.4756
    latitude = 42.4555
    events = fb.get_events_by_location(latitude, longitude)
    res = []
    for event in events:
        if filter_event_for_food(event):
            res.append(event)
    return res