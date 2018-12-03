//
//  Event.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/25.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import Foundation

class Event{
    var id: Int!
    var eventImgName: String!
    var eventName: String!
    var eventDate: Date!
    var specificLocation: String!//e.g. eventLocation[0] = "Duffield Hall", eventLocation[1] = "Central"
    var typeLocation: String!
    var eventFood: String!
    var eventDetail: String!
    var locationTypes: [String] = ["Central", "North", "West", "East", "Other"]
    var latitude: Double = 0
    var longitude: Double = 0
    
    init(id: Int, eventImgName: String, eventName: String, eventDate: Date, specificLocation: String, eventFood: String, eventDetail: String, latitude: Double, longtidue: Double){
        self.id = id
        self.eventImgName = eventImgName
        self.eventName = eventName
        self.eventDate = eventDate
        self.specificLocation = specificLocation
        self.eventFood = eventFood
        self.eventDetail = eventDetail
        self.latitude = latitude
        self.longitude = longtidue
        if (specificLocation.contains("Duffield") || specificLocation.contains("Statler") ||
            specificLocation.contains("Upson") || specificLocation.contains("Phillips") ||
            specificLocation.contains("Olin") || specificLocation.contains("Carpenter") ||
            specificLocation.contains("Goldwin") || specificLocation.contains("Klarman") ||
            specificLocation.contains("Rockefeller") || specificLocation.contains("Big Red Barn") ||
            specificLocation.contains("Day") || specificLocation.contains("Caldwell") ||
            specificLocation.contains("A. D. White") || specificLocation.contains("Willard") ||
            specificLocation.contains("Jennie") || specificLocation.contains("Kennedy") ||
            specificLocation.contains("Physical Science") || specificLocation.contains("Trillium") ||
            specificLocation.contains("Clark") || specificLocation.contains("Arts Quad") ||
            specificLocation.contains("Engineering Quad") || specificLocation.contains("Ag Quad") || specificLocation.contains("Gates")){
            self.typeLocation = locationTypes[0]
        } else if (specificLocation.contains("rpcc") || specificLocation.contains("RPCC") ||
            specificLocation.contains("Risley") || specificLocation.contains("Takton") ||
            specificLocation.contains("Appel") || specificLocation.contains("Africana Studies") ||
            specificLocation.contains("Robert") || specificLocation.contains("Balch")){
            self.typeLocation = locationTypes[1]
        } else if (specificLocation.contains("Becker") || specificLocation.contains("Bethe") ||
            specificLocation.contains("West")){
            self.typeLocation = locationTypes[2]
        } else if (specificLocation.contains("Humphreys") || specificLocation.contains("Dairy") ||
            specificLocation.contains("Botanic")){
            self.typeLocation = locationTypes[3]
        } else {
            self.typeLocation = locationTypes[4]
        }
    }
    func getName() -> String{
        return eventName
    }
    func getAddress() -> String{
        return specificLocation
    }
    func getLatitude() -> Double{
        return latitude
    }
    func getLongitude() -> Double{
        return longitude
    }
}
