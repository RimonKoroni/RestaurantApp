//
//  StringExtention.swift
//  RestaurantApp
//
//  Created by Rimon on 9/10/16.
//  Copyright © 2016 SSS. All rights reserved.
//

extension String {
    struct NumberFormatter {
        static let instance = NSNumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.numberFromString(self)?.doubleValue
    }
    var integerValue:Int? {
        return NumberFormatter.instance.numberFromString(self)?.integerValue
    }
}