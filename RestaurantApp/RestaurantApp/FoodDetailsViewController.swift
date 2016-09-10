//
//  FoodDetailsViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/27/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class FoodDetailsViewController: UIViewController , iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var tableNumber: UILabel!
    
    var lang : String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var foodType : FoodType!
    var foodService = FoodService()
    var foods : [Food]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        carousel.type = .Linear
        self.title = self.foodType.getName(lang)
        loadFoods()
        
        let tableNumber = self.userDefaults.valueForKey("tableNumber") as! Int
        self.tableNumber.text = String(tableNumber)
        
    }
    
    
    func loadFoods() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        foodService.getFoods(self.foodType.id, forEditing: 0, onComplition: {
            (result) -> Void in
            self.foods = result
            dispatch_sync(dispatch_get_main_queue(), {
                self.carousel.reloadData()
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
            })
        })

    }
    
    @IBAction func goToMenu(sender: AnyObject) {
        self.carousel.hidden = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.foods.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        let view = FoodDetailsView(food: self.foods[index], frame: self.carousel.bounds)
        //view.frame = self.carousel.bounds
        /*view.foodDescription.text = self.foods[index].getDescription(lang)
        view.foodTitle.text = self.foods[index].getName(lang)
        if let url = NSURL(string: self.foods[index].imageUrl) {
            if let data = NSData(contentsOfURL: url) {
                view.foodImage.image = UIImage(data: data)
            }
        }
        view.foodPrice.text = "\(self.foods[index].price)TL"*/
        return view
        
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.1
        }
        return value
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
        self.carousel.hidden = true
        self.navigationController?.popViewControllerAnimated(true)
    }
}