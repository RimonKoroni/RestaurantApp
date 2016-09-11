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
    @IBOutlet weak var foodTypesCollectionView: UICollectionView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var foodTypes : [FoodType] = []
    var lang : String!
    var foodTypeService = FoodTypesService()
    var tableNumberService = TableNumberService()
    var imageDataService = ImageDataService()
    var selectedFoodType : FoodType!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationControllerHelper.configureNavigationController(self, title: "foodTypeTitle")
        lang = userDefaults.valueForKey("lang") as! String
        let carts : [Cart] = []
        let cartsData = NSKeyedArchiver.archivedDataWithRootObject(carts)
        userDefaults.setObject(cartsData, forKey: "carts")
        userDefaults.synchronize()
        addLeftNavItemOnView ()
        
        getFoodTypes()
        getTableNumber()
    }
    
 
    func getFoodTypes() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        foodTypeService.getAllFoodTypes({
            (result) -> Void in
            self.foodTypes = result
            dispatch_sync(dispatch_get_main_queue(), {
                self.foodTypesCollectionView.reloadData()
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
            })
        })
    }
    
    func getTableNumber() {
        tableNumberService.getTableNumber({
            () -> Void in
            dispatch_sync(dispatch_get_main_queue(), {
                let tableNumber = self.userDefaults.valueForKey("tableNumber") as! Int
                self.tableNumber.text = String(tableNumber)
            })
        })

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foodTypes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("foodCell", forIndexPath:indexPath) as! FoodCollectionViewCell
        
        cell.foodTypeName.text = self.foodTypes[indexPath.row].getName(lang)
        
        let imageData = self.imageDataService.getByUrl(self.foodTypes[indexPath.row].imageUrl)
        
        if imageData == nil {
            self.imageDataService.loadImage(self.foodTypes[indexPath.row].imageUrl, onComplition: {
                (data) -> Void in
                self.imageDataService.insert(self.foodTypes[indexPath.row].imageUrl, image: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    cell.foodImage.image = UIImage(data: data!)
                }
            })

        } else {
            cell.foodImage.image = UIImage(data: imageData!)
        }
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedFoodType = self.foodTypes[indexPath.row]
        performSegueWithIdentifier("showFoodsDetailsSegue", sender: self)
        
    }

    @IBAction func goToHome(sender: AnyObject) {
        let startViewController = storyboard!.instantiateViewControllerWithIdentifier("StartViewController") as! StartViewController
        self.presentViewController(startViewController, animated:true, completion:nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "moveFromMenuToCartSegue" {
            let destinationViewController = segue.destinationViewController as! CartViewController
            destinationViewController.fromMenu = true
        }
        
        if segue.identifier == "showFoodsDetailsSegue" {
            let destinationViewController = segue.destinationViewController as! FoodDetailsViewController
            destinationViewController.foodType = self.selectedFoodType
        }
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
        if (self.lang.containsString("ar")) {
            buttonBack.setImage(UIImage(named: "arBackButton"), forState: .Normal)
            
        }
        else {
            buttonBack.setImage(UIImage(named: "enBackButton"), forState: .Normal)
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