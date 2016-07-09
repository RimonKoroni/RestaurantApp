//
//  ImageData.swift
//  
//
//  Created by SSS on 7/10/16.
//
//

import Foundation
import CoreData


class ImageData: GenericDomain {

    @NSManaged var url: String?
    @NSManaged var image: NSData?
    
    // Insert code here to add functionality to your managed object subclass

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: insertIntoManagedObjectContext)
    }
    
    init(url: String, image: NSData ) {// appointment: NSManagedObject
        super.init(entityName: "ImageData")
        self.url = url
        self.image = image
        
    }
    
    init() {
        super.init(entityName: "ImageData")
        
        
    }
    
    //    override func clone(object : NSManagedObject) {
    //        let Related_Meeting_Minute = object as! Related_Meeting_Minute
    //        employee.name = name
    //        employee.position = position
    //        employee.id = id
    //        employee.salary = salary
    //    }
    //
    override func getClassName() -> String {
        return "ImageData"
    }
}
