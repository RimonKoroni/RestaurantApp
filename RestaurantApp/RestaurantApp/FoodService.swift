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

class FoodService {
    
        
    func getFoods(foodTypeId: Int, forEditing : Int, onComplition: (foods : [Food]) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/FoodRest/getFood/\(foodTypeId)/\(forEditing)"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            var result : [Food] = []
            let foods = finalJsonResponse.array
            
            if foods != nil {
                for item in foods! {
                    result.append(Food(json: item))
                }
            }
            onComplition(foods: result)
        })
    }
    
    func addOrEditFood(foodTypeId: Int, forEditing: Bool, json : JSON, onComplition: (status : Int) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        var sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/FoodRest/addFood/\(foodTypeId)"
        if forEditing {
            sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/FoodRest/editFood"
        }
        RestApiManager.makeHTTPPostRequest(sreviceUrl, body: json.dictionaryObject!, onCompletion: {(finalJsonResponse , error) -> Void in
            let status = finalJsonResponse["status"].int
            onComplition(status: status!)
        })
    }
    
    func deleteFood(id : Int, onComplition: (status : Int) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/FoodRest/deleteFood/\(id)"
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            let status = finalJsonResponse["status"].int
            onComplition(status: status!)
        })
    }
}
