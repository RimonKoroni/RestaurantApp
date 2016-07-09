//
//  GenericDomain.swift
//  CDT
//
//  Created by SSS on 5/18/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON
class GenericDomain: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: insertIntoManagedObjectContext)
    }
    
    init(entityName : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext)!
        super.init(entity: entity, insertIntoManagedObjectContext: managedContext)
    }
    
    func clone(object : NSManagedObject){}
    func getClassName() -> String {return ""}
    func getJson() ->  JSON{
        return [:]
    }
    func toJson(columnName: String, columnValue: String , columnType : String) -> JSON {
        var dictionary = Dictionary<String , String>()
        dictionary["columnName"] = columnName
        dictionary["columnValue"] = columnValue
        dictionary["columnType"] = columnType
        
        let json = JSON.init(dictionary)
        return json
    }
    func getName(language : String) -> String {
        return ""
    }
}