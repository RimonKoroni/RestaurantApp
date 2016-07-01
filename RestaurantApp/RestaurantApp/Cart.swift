//
//  Cart.swift
//  RestaurantApp
//
//  Created by SSS on 7/1/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class Cart {
    
    var food : Food!
    var count : Int!
    
    init(food : Food, count : Int) {
        self.food = food
        self.count = count
    }
}