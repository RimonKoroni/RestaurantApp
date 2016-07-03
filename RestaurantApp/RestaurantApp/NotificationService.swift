//
//  NotificationService.swift
//  RestaurantApp
//
//  Created by SSS on 7/4/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class NotificationService {
    
    func getAllNotification(onComplition: (orders : [Order]) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/OrderRest/getUnservedOrders"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            var result : [Order] = []
            let orders = finalJsonResponse.array
            
            if orders != nil {
                for item in orders! {
                    result.append(Order(json: item))
                }
            }
            onComplition(orders: result)
        })
    }
    
}