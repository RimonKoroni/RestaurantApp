//
//  FoodDetailsViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/27/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class OrderViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    

    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var orderItemsTableView: UITableView!
    var lang : String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var orderId : Int!
    let orderService : OrderService = OrderService()
    var orderItems : [OrderItem] = []
    var delegate : NotificationDelegate!
    //var fromNotification : Bool = false
    
    override func viewDidLoad() {
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        notificationView.layer.cornerRadius = 10
        self.title = NSLocalizedString("notificationTitle", comment: "")
        getOrderItems()
    }
    
    func getOrderItems() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        orderService.getOrderItems(self.orderId, onComplition: {
            (result) -> Void in
            self.orderItems = result
            dispatch_sync(dispatch_get_main_queue(), {
                self.orderItemsTableView.reloadData()
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
            })
        })
    }
    
    @IBAction func goToNotification(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func goToMenu(sender: AnyObject) {
        let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
        self.presentViewController(adminStartViewController, animated:true, completion:nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("orderCell") as! OrderCell
        cell.count.text = "\(orderItems[indexPath.row].count)"
        if let url = NSURL(string: orderItems[indexPath.row].foodImage) {
            if let data = NSData(contentsOfURL: url) {
                cell.foodImage.image = UIImage(data: data)
            }
        }
        cell.foodName.text = orderItems[indexPath.row].getName(lang)
        return cell
        
    }
    
    
    
    @IBAction func acceptOrder(sender: AnyObject) {
        self.orderService.serveOrder(self.orderId, onComplition: {
            (status) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {
                if status == 1 {
                    self.view.makeToast(message: NSLocalizedString("serveOrderSuccessMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                    self.delegate.refreshTable()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.view.makeToast(message: NSLocalizedString("serveOrderFaildMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                }
            })
        })
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
        
        self.navigationController?.popViewControllerAnimated(true)

    }
}