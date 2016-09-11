//
//  TableNumber.swift
//  RestaurantApp
//
//  Created by Rimon on 9/11/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation


class TableNumber {
    
    var id : Int
    var number : Int
    
    
    init(id : Int, number : Int) {
        
        self.id = id
        self.number = number
    }
    
    
    init(json : JSON) {
        self.id = json["id"].int!
        self.number = json["tableNumber"].int!
        
    }
    
    func getJson() -> JSON {
        var dic = Dictionary<String , Int>()
        dic["id"] = self.id
        dic["tableNumber"] = self.number
        return JSON.init(dic)
    }
}