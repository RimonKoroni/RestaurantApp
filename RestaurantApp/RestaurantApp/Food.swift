//
//  File.swift
//  RestaurantApp
//
//  Created by SSS on 7/1/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class Food {
    
    var id : Int!
    var arabicName : String!
    var englishName : String!
    var turkishName : String!
    var arabicDescription : String!
    var englishDescription : String!
    var turkishDescription : String!
    var imageUrl : String!
    var price : Double!
    
    init(json : JSON) {
        self.id = json["id"].int
        self.arabicName = json["arabicName"].string
        self.englishName = json["englishName"].string
        self.turkishName = json["turkishName"].string
        self.arabicDescription = json["arabicDescription"].string
        self.englishDescription = json["englishDescription"].string
        self.turkishDescription = json["turkishDescription"].string
        self.imageUrl = json["image"].string
        self.price = json["price"].double
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
    
    func getDescription(lang : String) -> String {
        if lang.containsString("ar") {
            return self.arabicDescription
        } else {
            if lang.containsString("en") {
                return self.englishDescription
            } else {
                return self.turkishDescription
            }
        }
    }
    
}