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
    
    @IBOutlet weak var tableNumber: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var foodTypes : [String] = []
    var lang : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarBackgroundImage = UIImage(named: "navigationBar");
        self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: .Default)
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        self.title = NSLocalizedString("foodTypeTitle", comment: "")
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
        
        performSegueWithIdentifier("showFoodsDetailsSegue", sender: self)
        
    }

    @IBAction func goToHome(sender: AnyObject) {
        let startViewController = storyboard!.instantiateViewControllerWithIdentifier("StartViewController") as! StartViewController
        self.presentViewController(startViewController, animated:true, completion:nil)
    }
    
    /**
     The addLeftNavItemOnView function is used for add backe button to the navigation bar.
     */
    func addLeftNavItemOnView () {
        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        // Create the back button
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        if (self.lang.containsString("en")) {
            buttonBack.setImage(UIImage(named: "enBackButton"), forState: .Normal)
            
        }
        else {
            buttonBack.setImage(UIImage(named: "arBackButton"), forState: .Normal)
        }
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.addTarget(self, action: #selector(self.leftNavButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)// Define the action of this button
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)// Create the left bar button
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)// Set the left bar button in the navication
        
        
        
    }
    
    /**
     The leftNavButtonClick function is an action which triggered when user press on the backButton.
     */
    func leftNavButtonClick(sender:UIButton!) {
        let startViewController = storyboard!.instantiateViewControllerWithIdentifier("StartViewController") as! StartViewController
        self.presentViewController(startViewController, animated:true, completion:nil)
    }

    
}