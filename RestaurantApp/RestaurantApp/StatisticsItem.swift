//
//  StatisticsItem.swift
//  RestaurantApp
//
//  Created by Rimon on 9/15/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class StatisticsItem {
    
    var key : String!
    var value : Int!
    
    init(json : JSON) {
        self.key = json["key"].string
        self.value = json["value"].int
    }
    
    init(key : String, value : Int) {
        self.key = key
        self.value = value
    }
}
