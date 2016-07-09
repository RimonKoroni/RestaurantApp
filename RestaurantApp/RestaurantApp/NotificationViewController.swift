//
//  NotificationViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/30/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

protocol NotificationDelegate {
   func refreshTable()
   func refreshNotification(count : Int)
}

class NotificationViewController : UIViewController , UITableViewDataSource, UITableViewDelegate, NotificationDelegate {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    @IBOutlet weak var noNotificationLable: UILabel!
    
    var lang : String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var fromMenu : Bool = false
    let notificationService = NotificationService()
    var orders : [Order] = []
    var selectedOrderId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarBackgroundImage = UIImage(named: "navigationBar");
        self.navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: .Default)

        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        notificationView.layer.cornerRadius = 15
        
        self.title = NSLocalizedString("notificationTitle", comment: "")
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Vladimir Script", size: 50)!]
        self.noNotificationLable.text = NSLocalizedString("noNotificationMessage", comment: "")
        getOrders()
        notificationService.getNotiNumber({ (count) -> Void in
            self.userDefaults.setInteger(count, forKey: "notification")
            self.refreshNotification(count)
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let count = self.userDefaults.valueForKey("notification") as! Int
        self.refreshNotification(count)
    }
    
    func getOrders() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        notificationService.getAllNotification({
            (result) -> Void in
            self.orders = result
            dispatch_sync(dispatch_get_main_queue(), {
                self.ordersTableView.reloadData()
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
                if self.orders.count == 0 {
                    self.noNotificationLable.hidden = false
                } else {
                    self.noNotificationLable.hidden = true
                }
            })
        })
    }
    
    func refreshTable() {
        getOrders()
    }
    
    @IBAction func goToHome(sender: AnyObject) {
        let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
        self.presentViewController(adminStartViewController, animated:true, completion:nil)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as! NotificationCell
        cell.tableNumber.text = "\(orders[indexPath.row].tableNumber)"
        cell.notificationDate.text = orders[indexPath.row].requestDate.getTime()
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedOrderId = orders[indexPath.row].id
        self.performSegueWithIdentifier("goToOrderViewControllerSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "goToOrderViewControllerSegue" {
            let controller = segue.destinationViewController as! OrderViewController
            controller.orderId = self.selectedOrderId
            controller.delegate = self
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
        let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
        self.presentViewController(adminStartViewController, animated:true, completion:nil)
    }

}