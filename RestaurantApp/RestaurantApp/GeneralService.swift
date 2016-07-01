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

class GeneralService {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func getTableNumber(onComplition: () -> Void)  {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let deviceName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/TableNumberRest/getFoodTypes/\(deviceName)"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            let tableNumber = finalJsonResponse["tableNumber"].int
            self.userDefaults.setValue(tableNumber, forKey: "tableNumber")
            onComplition()
        })
    }
}
