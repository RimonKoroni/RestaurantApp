//
//  ImageDataService.swift
//  RestaurantApp
//
//  Created by SSS on 7/10/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

import Foundation
import CoreData
import SwiftyJSON
class ImageDataService {

    var imageDataDao = ImageDataDao()
    func insert(url : String, image : NSData) {
        _ = ImageData(url: url, image: image)
        imageDataDao.save()
    }
    
    func delete(url : String){
        let predicate = NSPredicate(format: "url = %@", url)
        var predicates = [NSPredicate]()
        predicates.append(predicate)
        
        let imageData = imageDataDao.getByWhere(predicates).first as! ImageData?
        if imageData != nil {
            imageDataDao.delete(imageData!)
            print("image deleted")
        } else {
            print("image not deleted")
        }
        
    }
    
    func getByUrl(url : String) -> NSData? {
        
        let predicate = NSPredicate(format: "url = %@", url)
        var predicates = [NSPredicate]()
        predicates.append(predicate)
        
        let imageData = imageDataDao.getByWhere(predicates).first as! ImageData?
        if imageData != nil {
            return imageData!.image
        } else {
            return nil
        }
    }
    
    func loadImage(url : String, onComplition: (data : NSData?) -> Void) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let serverUrl = dict.objectForKey("serverUrl") as! String
        let fullUrl = serverUrl + url
        let request = NSMutableURLRequest(URL: NSURL(string: fullUrl)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    onComplition(data: nil)
                    return
            }
            onComplition(data: data!)
        })
        task.resume()
    }
    
    func getAll() -> [ImageData] {
        return self.imageDataDao.getAll() 
    }
}