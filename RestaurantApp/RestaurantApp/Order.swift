//
//  Order.swift
//  RestaurantApp
//
//  Created by SSS on 7/4/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class Order {
    
    var id : Int!
    var tableNumber : Int!
    var requestDate : NSDate!
    
    init(json : JSON) {
        self.id = json["id"].int
        self.tableNumber = json["tableNumber"].int
        let int1 = json["requestDate"].doubleValue
        let epocTime1 = NSTimeInterval(int1/1000 + 10800)
        self.requestDate = NSDate(timeIntervalSince1970: epocTime1)
    }

}