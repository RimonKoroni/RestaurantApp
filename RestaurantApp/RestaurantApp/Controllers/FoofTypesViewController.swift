//
//  FoofTypesViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/23/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class FoodTypesViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var foodTypes : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarBackgroundImage = UIImage(named: "navigationBar");
        self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: .Default)
        
    }
    
 
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("foodCell", forIndexPath:indexPath) as! FoodCollectionViewCell
        
        cell.foodTypeName.text = "Fishes"
        cell.foodImage.image = UIImage(named: "foodType")
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }

    
}