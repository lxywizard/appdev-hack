//
//  NetworkManager.swift
//  FreeFood
//
//  Created by Quintessa Qiao on 2018/11/30.
//  Copyright © 2018 Quintessa Qiao. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager{
    private static let endpoint = "http://35.227.40.205/api/events/"
    
    static func getEvents(completion: @escaping([EventStruct]) -> Void){
        Alamofire.request(endpoint, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments){
                    print(json)
                }
                
                let jsonDecoder = JSONDecoder()
                if let eventResponse = try? jsonDecoder.decode(EventResponse.self, from: data){
                    completion(eventResponse.data)
                }
                else{
                    print("Invalid Response Data")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
