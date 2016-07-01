//
//  FoodDetailsViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/27/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class CartViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    
    var lang : String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var fromMenu : Bool = false
    var carts : [Cart]! = []
    override func viewDidLoad() {
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        self.title = NSLocalizedString("cartTitle", comment: "")
        let data = NSUserDefaults.standardUserDefaults().objectForKey("carts") as? NSData
        self.carts = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Cart]
        let tableNumber = self.userDefaults.valueForKey("tableNumber") as! Int
        self.tableNumber.text = String(tableNumber)
    }
    

    @IBAction func goToMenu(sender: AnyObject) {
        if fromMenu {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cartCell") as! CartCell
        cell.cart = self.carts[indexPath.row]
        return cell
        
    }
    
    @IBAction func rejectOrder(sender: AnyObject) {
        
    }
    
    
    @IBAction func acceptOrder(sender: AnyObject) {
        
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
        if fromMenu {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
}