//
//  Event.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/25.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import Foundation

class Event{
    var eventImgName: String!
    var eventName: String!
    var eventTime: [String]!//e.g. eventTime[0] = "Sat, Nov 10", eventTime[1] = "8AM-11AM"
    var eventLocation: [String]!//e.g. eventLocation[0] = "Duffield Hall", eventLocation[1] = "Central"
    var filterLocationsNum: Int!
    var filterTimesNum: Int!
    var eventFood: String!
    var eventDetail: String!
    
    
    init(eventImgName: String, eventName: String, eventTime: [String], eventLocation: [String], eventFood: String, eventDetail: String){
        self.eventImgName = eventImgName
        self.eventName = eventName
        self.eventTime = eventTime
        self.eventLocation = eventLocation
        //filterLocationsNum = 0
        //filterTimesNum = 0
        self.eventFood = eventFood
        self.eventDetail = eventDetail
    }
}
