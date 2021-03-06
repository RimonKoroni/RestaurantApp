//
//  NotificationService.swift
//  RestaurantApp
//
//  Created by SSS on 7/4/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class NotificationService {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
    
    func getNotiNumber(onComplition: (count : Int) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/OrderRest/getNumberOfNotification"
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            var result : Int = 0
            let count = finalJsonResponse["count"].int
            //print(count)
            if count != nil {
                result = count!
            }
            
            onComplition(count: result)
        })
    }
    
    @objc func checkForNewOrders()
    {
        //print("checkForNewOrders")
        let isRun = userDefaults.valueForKey("isRun") as! Bool
        
        if !isRun {
            //print("Start Check")
            userDefaults.setBool(true, forKey: "isRun")
            self.getNotiNumber({ (count) -> Void in
                
                if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    
                    if let naviationController = topController as? UINavigationController{
                        if let  notificationVC = naviationController.topViewController as? NotificationViewController {
                            
                            let temp = self.userDefaults.valueForKey("notification") as! Int
                            if count > temp {
                                notificationVC.refreshTable()
                            }
                            
                            notificationVC.refreshNotification(count)
                        }
                        
                        if let  orderVC = naviationController.topViewController as? OrderViewController {
                            orderVC.refreshNotification(count)
                        }
                        
                        if let  foodTypeDMVC = naviationController.topViewController as? FoodTypeDMViewController {
                            foodTypeDMVC.refreshNotification(count)
                        }
                        
                        if let  addOrEditFoodTypeVC = naviationController.topViewController as? AddOrEditFoodTypeViewController {
                            addOrEditFoodTypeVC.refreshNotification(count)
                        }
                        
                        if let  foodDmVC = naviationController.topViewController as? FoodDMViewController {
                            foodDmVC.refreshNotification(count)
                        }
                        
                        if let  addOrEditFoodVC = naviationController.topViewController as? addOrEditFoodViewController {
                            addOrEditFoodVC.refreshNotification(count)
                        }
                        
                        if let  tableNumberVC = naviationController.topViewController as? TableNumbersViewController {
                            tableNumberVC.refreshNotification(count)
                        }
                        
                        if let  statisticsVC = naviationController.topViewController as? StatisticsViewController {
                            statisticsVC.refreshNotification(count)
                        }
                        
                        if let  chartVC = naviationController.topViewController as? ChartViewController {
                            chartVC.refreshNotification(count)
                        }
                        
                        if let  dataVC = naviationController.topViewController as? DataViewController {
                            dataVC.refreshNotification(count)
                        }
                    }
                    
                }
                self.userDefaults.setInteger(count, forKey: "notification")
                self.userDefaults.setBool(false, forKey: "isRun")
            })
        }
    }

    
}
