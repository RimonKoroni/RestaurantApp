//
//  FoodDetailsViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/27/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

protocol CartDelegate {
    func deleteCart(cart : Cart)
    func calculatePrice(price : Double)
}

class CartViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, CartDelegate {
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var noCartsLabel: UILabel!
    
    var lang : String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var fromMenu : Bool = false
    var carts : [Cart]! = []
    var orderService  = OrderService()
    var totalPriceValue : Double = 0
    override func viewDidLoad() {
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        self.title = NSLocalizedString("cartTitle", comment: "")
        let data = NSUserDefaults.standardUserDefaults().objectForKey("carts") as? NSData
        self.carts = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Cart]
        let tableNumber = self.userDefaults.valueForKey("tableNumber") as! Int
        self.tableNumber.text = String(tableNumber)
        self.noCartsLabel.text = NSLocalizedString("noCartMessage", comment: "")
        if self.carts.count == 0 {
            noCartsLabel.hidden = false
        } else {
            noCartsLabel.hidden = true
        }
        self.setTotalPrice()
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
        let cart = self.carts[indexPath.row]
        
        if let url = NSURL(string: cart.foodImage) {
            if let data = NSData(contentsOfURL: url) {
                cell.foodImage.image = UIImage(data: data)
            }
        }
        cell.foodName.text = cart.foodName
        cell.foodPrice.text = "\(cart.foodPrice * Double(cart.count))$"
        cell.totalPrice = cart.foodPrice * Double(cart.count)
        cell.count.text = "\(cart.count)"
        cell.countNumber = cart.count
        cell.cart = cart
        cell.delegate = self
        return cell
    }
    
    @IBAction func rejectOrder(sender: AnyObject) {
        let data = NSUserDefaults.standardUserDefaults().objectForKey("carts") as? NSData
        var carts = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Cart]
        carts.removeAll()
        let cartsData = NSKeyedArchiver.archivedDataWithRootObject(carts)
        userDefaults.setObject(cartsData, forKey: "carts")
        userDefaults.synchronize()
        self.view.makeToast(message: NSLocalizedString("rejectOrderMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        self.carts.removeAll()
        self.cartTableView.reloadData()
        self.totalPrice.text = "0.0$"
        noCartsLabel.hidden = false
        goToPreviousController()
    }
    
    func goToPreviousController() {
        if self.fromMenu {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func acceptOrder(sender: AnyObject) {
        if self.carts.count == 0 {
            self.view.makeToast(message: NSLocalizedString("acceptOrderErrorMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        } else {
            orderService.sendOrder({ (status) -> Void in
                dispatch_sync(dispatch_get_main_queue(), {
                    if status == 1 {
                        self.view.makeToast(message: NSLocalizedString("acceptOrderSuccessMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                        self.carts.removeAll()
                        self.cartTableView.reloadData()
                        let data = NSUserDefaults.standardUserDefaults().objectForKey("carts") as? NSData
                        var carts = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Cart]
                        carts.removeAll()
                        let cartsData = NSKeyedArchiver.archivedDataWithRootObject(carts)
                        self.userDefaults.setObject(cartsData, forKey: "carts")
                        self.userDefaults.synchronize()
                        self.totalPrice.text = "0.0$"
                        self.goToPreviousController()
                    } else {
                        self.view.makeToast(message: NSLocalizedString("acceptOrderFaildMessage", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                    }
                })
            })
        }
    }
    
    func deleteCart(cart : Cart) {
        for i in 0..<self.carts.count {
            if self.carts[i].foodId == cart.foodId {
                self.carts.removeAtIndex(i)
                break
            }
        }
        
        if self.carts.count == 0 {
            noCartsLabel.hidden = false
        } else {
            noCartsLabel.hidden = true
        }
        
        self.cartTableView.reloadData()
        self.setTotalPrice()
    }
    
    func setTotalPrice()  {
        for cart in self.carts {
            totalPriceValue += Double(cart.count) * cart.foodPrice
        }
        self.totalPrice.text = "\(totalPriceValue)$"
    }
    
    func calculatePrice(price: Double) {
        self.totalPriceValue += price
        self.totalPrice.text = "\(totalPriceValue)$"
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