//
//  DaoUtil.swift
//  CDT
//
//  Created by SSS on 5/19/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class DaoUtil {
    
    class func genericName(fullName : String) -> String {
        let range = fullName.rangeOfString(".", options: .BackwardsSearch)
        if let range = range {
            return fullName.substringFromIndex(range.endIndex)
        } else {
            return fullName
        }
    }
}