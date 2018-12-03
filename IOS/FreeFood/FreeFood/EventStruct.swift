//
//  EventStruct.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/30.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import Foundation

struct EventResponse: Codable{
    //var success: Bool
    var data: [EventStruct]
}

struct EventStruct: Codable{
    var id: Int
    var name: String
    var location: String
    var longitude: String
    var latitude: String
    var datetime: String
    var content: String
}
