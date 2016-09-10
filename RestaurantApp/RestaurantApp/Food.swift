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
    var imageData : NSData?
    var isValid : Int!
    
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
        self.isValid = json["isvalid"].int
    }
    
    init() {
        
    }
    
    func getName(lang : String) -> String? {
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
    
    func getDescription(lang : String) -> String? {
        if self.arabicDescription == nil {
            return ""
        }
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
    
    
    func getJson() -> JSON {
        var dic = Dictionary<String , String>()
        dic["arabicName"] = self.arabicName
        dic["englishName"] = self.englishName
        dic["turkishName"] = self.turkishName
        dic["arabicDescription"] = self.arabicDescription
        dic["englishDescription"] = self.englishDescription
        dic["turkishDescription"] = self.turkishDescription
        dic["price"] = "\(self.price)"
        dic["isvalid"] = "\(self.isValid)"
        
        if self.id != nil {
            dic["id"] = "\(self.id)"
        }
        if self.imageData != nil {
            let data = self.imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            dic["image"] = data
        }
        return JSON.init(dic)
    }
    
}