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
    var imageDataService = ImageDataService()
    //var fromNotification : Bool = false
    
    override func viewDidLoad() {
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        notificationView.layer.cornerRadius = 15
        self.title = NSLocalizedString("notificationTitle", comment: "")
        getOrderItems()
        let count = self.userDefaults.valueForKey("notification") as! Int
        self.refreshNotification(count)
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
        let imageData = self.imageDataService.getByUrl(self.orderItems[indexPath.row].foodImage)
        
        if imageData == nil {
            self.imageDataService.loadImage(self.orderItems[indexPath.row].foodImage, onComplition: {
                (data) -> Void in
                self.imageDataService.insert(self.orderItems[indexPath.row].foodImage, image: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    cell.foodImage.image = UIImage(data: data!)
                }
            })
            
        } else {
            cell.foodImage.image = UIImage(data: imageData!)
        }

        
        cell.foodName.text = orderItems[indexPath.row].getName(lang)
        return cell
        
    }

    func refreshNotification(count : Int) {
        dispatch_async(dispatch_get_main_queue()) {
            if count == 0 {
                self.notificationView.hidden = true
            } else {
                self.notificationView.hidden = false
                self.notificationCount.text = String(count)
            }
        }
    }
    
    @IBAction func acceptOrder(sender: AnyObject) {
        self.orderService.serveOrder(self.orderId, onComplition: {
            (status) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {
                if status == 1 {
                    self.view.makeToast(message: NSLocalizedString("serveOrderSuccessMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                    let count = self.userDefaults.valueForKey("notification") as! Int
                    self.userDefaults.setInteger(count - 1 , forKey: "notification")
                    self.refreshNotification(count)
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
        
        self.navigationController?.popViewControllerAnimated(true)

    }
}