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

class TableNumberService {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func getTableNumber(onComplition: () -> Void)  {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let deviceName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/TableNumberRest/getTableNumber/\(deviceName)"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            let tableNumber = finalJsonResponse["tableNumber"].int
            self.userDefaults.setValue(tableNumber, forKey: "tableNumber")
            onComplition()
        })
    }
    
    
    
    func getAllTableNumbers(onComplition: (tableNumbers : [TableNumber]) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/TableNumberRest/getAllTableNumbers"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            var result : [TableNumber] = []
            let tableNumbers = finalJsonResponse.array
            
            if tableNumbers != nil {
                for item in tableNumbers! {
                    result.append(TableNumber(json: item))
                }
            }
            onComplition(tableNumbers: result)
        })
    }
    
    func deleteTableNumber(id : Int, onComplition: (status : Int) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/TableNumberRest/deleteTableNumber/\(id)"
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            let status = finalJsonResponse["status"].int
            onComplition(status: status!)
        })
    }
    
    func updateTableNumbers(json : JSON, onComplition: (status : Int) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/TableNumberRest/updateTableNumbers"
        RestApiManager.makeHTTPPostRequest(sreviceUrl, body: json.dictionaryObject!, onCompletion: {(finalJsonResponse , error) -> Void in
            let status = finalJsonResponse["status"].int
            onComplition(status: status!)
        })
    }
    
}
