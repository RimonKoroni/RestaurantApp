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

class FoodTypesService {
    
    func getAllFoodTypes(onComplition: (foodTypes : [FoodType]) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/FoodTypeRest/getFoodTypes"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            var result : [FoodType] = []
            let foodTypes = finalJsonResponse.array
            
            if foodTypes != nil {
                for item in foodTypes! {
                    result.append(FoodType(json: item))
                }
            }
            onComplition(foodTypes: result)
        })
    }
}
