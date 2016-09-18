//
//  StatisticsService.swift
//  RestaurantApp
//
//  Created by Rimon on 9/15/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class StatisticsService {
    
    func getStatisticData(reportType : Int, dateType : Int,
                          fromDate: String, toDate : String, lang : String,
                          onComplition: (statisticsItems : [StatisticsItem]) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let sreviceUrl = "\(serverUrl)/WebServiceProject/MobileServlet/StatisticsRest/getStatistics/\(reportType)/\(dateType)/" + fromDate + "/" + toDate + "/" + lang
        
        RestApiManager.makeHTTPGetRequest(sreviceUrl, onCompletion: {(finalJsonResponse , error) -> Void in
            var result : [StatisticsItem] = []
            let statisticsItems = finalJsonResponse.dictionary
            
            if statisticsItems != nil {
                for (key,value) in statisticsItems! {
                    result.append(StatisticsItem(key: key, value: value.int!))
                }
            }
            onComplition(statisticsItems: result)
        })
    }
    
}
