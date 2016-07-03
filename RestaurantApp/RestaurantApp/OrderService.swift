//
//  FoodTypesService.swift
//  RestaurantApp
//
//  Created by SSS on 7/1/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class OrderService {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func sendOrder(onComplition: (status : Int) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let data = NSUserDefaults.standardUserDefaults().objectForKey("carts") as? NSData
        let carts = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Cart]
        var dictionary = [String : JSON]()
        let tableNumber = self.userDefaults.valueForKey("tableNumber") as! Int
        dictionary["tableNumber"] = JSON("\(tableNumber)")
        var orderItems = [JSON]()
        for cart in carts {
            var dict = [String : JSON]()
            dict["foodId"] = JSON("\(cart.foodId)")
            dict["count"] = JSON("\(cart.count)")
            
            orderItems.append(JSON.init(dict))
        }
        dictionary["orderItems"] = JSON.init(orderItems)
        
        var finalJsonRequest = JSON.init(dictionary)
        
        
        RestApiManager.makeHTTPPostRequest("\(serverUrl)/WebServiceProject/MobileServlet/OrderRest/createOrder", body: finalJsonRequest.dictionaryObject! ,onCompletion: {(finalJsonResponse , error) -> Void in
            let status = finalJsonResponse["status"].int
            onComplition(status: status!)
        })
        
    }
}
