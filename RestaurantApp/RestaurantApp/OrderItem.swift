//
//  Order.swift
//  RestaurantApp
//
//  Created by SSS on 7/4/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class OrderItem {
    
    var foodImage : String!
    var arabicName : String!
    var englishName : String!
    var turkishName : String!
    var count : Int!
    
    init(json : JSON) {
        self.foodImage = json["foodImage"].string
        self.arabicName = json["arabicName"].string
        self.englishName = json["englishName"].string
        self.turkishName = json["turkishName"].string
        self.count = json["count"].int
    }
    
    func getName(lang : String) -> String {
        if lang.containsString("ar") {
            return self.arabicName
        } else {
            if lang.containsString("en") {
                return self.englishName
            } else {
                return self.turkishName
            }
        }
    }
}