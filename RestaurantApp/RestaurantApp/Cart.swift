//
//  Cart.swift
//  RestaurantApp
//
//  Created by SSS on 7/1/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class Cart: NSObject, NSCoding  {
    
    var foodId : Int!
    var count : Int!
    var foodName : String!
    var foodImage : String!
    var foodPrice : Double!
    
    init(foodId : Int, count : Int, foodName : String, foodImage : String!, foodPrice : Double) {
        self.foodId = foodId
        self.count = count
        self.foodName = foodName
        self.foodImage = foodImage
        self.foodPrice = foodPrice
    }
   
    required convenience init?(coder decoder: NSCoder) {
        self.init(
            foodId: decoder.decodeIntegerForKey("foodId"),
            count: decoder.decodeIntegerForKey("count"),
            foodName: decoder.decodeObjectForKey("foodName") as! String,
            foodImage: decoder.decodeObjectForKey("foodImage") as! String,
            foodPrice: decoder.decodeDoubleForKey("foodPrice")
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInt(Int32(self.foodId), forKey: "foodId")
        coder.encodeInt(Int32(self.count), forKey: "count")
        coder.encodeObject(self.foodName, forKey: "foodName")
        coder.encodeObject(self.foodImage, forKey: "foodImage")
        coder.encodeDouble(self.foodPrice, forKey: "foodPrice")
    }
    
}