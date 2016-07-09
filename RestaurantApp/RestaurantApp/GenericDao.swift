//
//  GenericDao.swift
//  CDT
//
//  Created by SSS on 5/18/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class GenericDao<Domain : NSManagedObject> {
    let managedContext : NSManagedObjectContext
    let appDelegate : AppDelegate
    
    init() {
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
    }
    
    func save() -> Bool {
        do{
            try managedContext.save()
            return true
        }catch{
            print("Error while add object")
            return false
        }
    }
    
    func delete(object : Domain) -> Bool {

        managedContext.deleteObject(object)
        do{
            try managedContext.save()
            return true
        }catch{
            print("Error while delete object")
            return false
        }
    }
    
    func getAll() -> [Domain] {
        
        let request = NSFetchRequest(entityName: DaoUtil.genericName(NSStringFromClass(Domain)))
        var result = [Domain]()
        do{
            result = try managedContext.executeFetchRequest(request) as! [Domain]
        }catch{
            print("Error while fetch objects")
        }
        return result
    }
    
    func getById(id:Int?) -> Domain? {
        if id == nil {
            return nil
        }
        let request = NSFetchRequest(entityName: DaoUtil.genericName(NSStringFromClass(Domain)))
        let idAttribute = "id"
        let predicate =  NSPredicate(format: "%K == %D",   idAttribute , id!)
        request.predicate = predicate
        var result = [Domain]()
        do{
            result = try managedContext.executeFetchRequest(request) as! [Domain]
        }catch{
            print("Error while fetch objects")
        }
        
        if result.isEmpty {
            return nil
        }
        
        return result[0]
        
    }
    
    func deleteById(id:Int) -> Bool{
        let request = NSFetchRequest(entityName: DaoUtil.genericName(NSStringFromClass(Domain)))
        let idAttribute = "id"
        let predicate =  NSPredicate(format: "%K == %D",   idAttribute , id)
        request.predicate = predicate
        var result = [Domain]()
        do{
            result = try managedContext.executeFetchRequest(request) as! [Domain]
        }catch{
            print("Error while fetch objects")
        }
        if(result.count != 0){
            self.delete(result[0])
            save()
            return true
        }
        else{
            return false
        }
        
    }
    
    func deletAll() -> Int {
        var numOfDeleted = 0
        for domain in self.getAll(){
            self.delete(domain)
            numOfDeleted += 1
        }
        return numOfDeleted
    }
    
    func getModifiedRecords(lastSync : NSDate) -> JSON {
        return [:]
    }
    
    func getByWhere(predicates : [NSPredicate])-> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest(entityName: DaoUtil.genericName(NSStringFromClass(Domain)))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        var result = [Domain]()
        do{
            result = try managedContext.executeFetchRequest(fetchRequest) as! [Domain]
        }catch{
            print("Error while fetch objects")
        }
        return result
    }
    
    func insertRecrod (json: JSON , dictionary:[String : NSManagedObject ]) -> NSManagedObject?{
        return nil
    }
    
    func updateRecord (id :Int,json: JSON , dictionary:[String : NSManagedObject ]) -> NSManagedObject?{
        return nil
    }
    
    func fastDeleteObject() {
//        
//        let fetchRequest = NSFetchRequest(entityName:  DaoUtil.genericName(NSStringFromClass(Domain)))
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try appDelegate.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: managedContext)
//        } catch {
//            // TODO: handle the error
//        }
    print(DaoUtil.genericName(NSStringFromClass(Domain) + "  " + "\(deletAll())"))
    }
    
}