//
//  File.swift
//  RestaurantApp
//
//  Created by SSS on 7/1/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class FoodType {
 
    var id : Int!
    var arabicName : String!
    var englishName : String!
    var turkishName : String!
    var imageUrl : String!
    
    init(id : Int, arabicName : String, englishName : String, turkishName : String, imageUrl : String!) {
        self.id = id
        self.arabicName = arabicName
        self.englishName = englishName
        self.turkishName = turkishName
        self.imageUrl = imageUrl
    }
    
    init(json : JSON) {
        self.id = json["id"].int
        self.arabicName = json["arabicName"].string
        self.englishName = json["englishName"].string
        self.turkishName = json["turkishName"].string
        self.imageUrl = json["image"].string
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