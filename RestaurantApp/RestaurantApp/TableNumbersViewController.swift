//
//  TableNumbersViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/11/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

protocol TableNumberDelegate {
    func deleteTableNumber(tableNumber : TableNumber)
}


class TableNumbersViewController: UIViewController, TableNumberDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noTableNumberLable: UILabel!
    @IBOutlet weak var deleteConfirmationLabel: UILabel!
    
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var tableNumbers : [TableNumber] = []
    var newNumbers : [Int] = []
    var lang : String!
    var tableNumberService = TableNumberService()
    var selectedTableNumber : TableNumber!
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = userDefaults.valueForKey("lang") as! String
        NavigationControllerHelper.configureNavigationController(self, title: NSLocalizedString("tableNumberTitle", comment: ""))
        addLeftNavItemOnView ()
        self.noTableNumberLable.text = NSLocalizedString("noTableNumberMessage", comment: "")
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getTableNumbers()
       
        self.tableView.reloadData()
        notificationView.layer.cornerRadius = 15
        self.refreshNotification(self.userDefaults.valueForKey("notification") as! Int)
    }
    
    
    func getTableNumbers() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        tableNumberService.getAllTableNumbers({
            (result) -> Void in
            self.newNumbers.removeAll()
            self.tableNumbers = result
            for item in self.tableNumbers {
                self.newNumbers.append(item.number)
            }
            dispatch_sync(dispatch_get_main_queue(), {
                if self.tableNumbers.count == 0 {
                    self.noTableNumberLable.hidden = false
                }
                self.tableView.reloadData()
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
            })
        })
        
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
    
    @IBAction func goToHome(sender: AnyObject) {
        let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
        self.presentViewController(adminStartViewController, animated:true, completion:nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableNumbers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableNumberCell") as! TableNumberCell
        cell.delegate = self
        cell.oldNumber.text = "\(tableNumbers[indexPath.row].number)"
        cell.tableNumber = tableNumbers[indexPath.row]
        //cell.newNumber.delegate = self
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedTableNumber = tableNumbers[indexPath.row]
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        for i in 0..<self.tableNumbers.count {
            let indexPath = NSIndexPath(forRow:i, inSection:0)
            let cell : TableNumberCell = self.tableView.cellForRowAtIndexPath(indexPath) as! TableNumberCell
            if !cell.newNumber.text!.isEmpty {
                if cell.newNumber.text!.integerValue == nil {
                    self.view.makeToast(message: NSLocalizedString("tableNumberValidationError", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                    return
                }
                self.newNumbers[i] = cell.newNumber.text!.integerValue!
            } else {
                self.newNumbers[i] = self.tableNumbers[i].number
            }
        }
        
        let unique = Array(Set(self.newNumbers))
        if unique.count != self.newNumbers.count {
            self.view.makeToast(message: NSLocalizedString("tableNumbersNotUniqueError", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
            
        } else {
            var newTableNumbers : [JSON] = []
            
            for i in 0..<self.newNumbers.count {
                if self.tableNumbers[i].number != self.newNumbers[i] {
                    newTableNumbers.append(TableNumber(id: self.tableNumbers[i].id, number: self.newNumbers[i]).getJson())
                }
            }
            if newTableNumbers.count > 0 {
                var dic : [String : JSON] = [:]
                dic["tableNumbers"] = JSON.init(newTableNumbers)
                tableNumberService.updateTableNumbers(JSON.init(dic), onComplition: { (status) -> Void in
                    if status == 1 {
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.view.makeToast(message: NSLocalizedString("updateTableNumberSuccessfully", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                            self.getTableNumbers()
                            self.tableView.reloadData()
                            EZLoadingActivity.hide()
                            self.view.userInteractionEnabled = true
                        })
                    } else {
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.view.makeToast(message: NSLocalizedString("operationFaild", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                            EZLoadingActivity.hide()
                            self.view.userInteractionEnabled = true
                        })
                        
                    }
                })
            }
        }
    }
    
    // Override tableNumber delegation functions
    
    func deleteTableNumber(tableNumber: TableNumber) {
        self.deleteConfirmationLabel.text = NSLocalizedString("deleteTableMessage", comment: "") + "\(tableNumber.number)" + "?"
        showModal()
        self.selectedTableNumber = tableNumber
    }
    
    @IBAction func acceptDeleteAction(sender: AnyObject) {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        tableNumberService.deleteTableNumber(self.selectedTableNumber.id, onComplition: {(status: Int) -> Void in
            if status == 1 {
                //self.imageDataService.delete(self.selectedFoodType.imageUrl)
                self.getTableNumbers()
                dispatch_sync(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    EZLoadingActivity.hide()
                    self.view.userInteractionEnabled = true
                    self.hideModal()
                    self.view.makeToast(message: NSLocalizedString("deletedSuccessfully", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                })
            } else {
                self.view.makeToast(message: NSLocalizedString("operationFaild", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
            }
        })
    }
    
    
    @IBAction func rejectDeleteAction(sender: AnyObject) {
        hideModal()
    }
    
    func showModal() {
        self.modalViewContainer.alpha = 0
        self.modalViewContainer.hidden = false
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.modalViewContainer.alpha = 1
            
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func hideModal() {
        self.modalViewContainer.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.modalViewContainer.alpha = 0
            
            }, completion: { (finished: Bool) -> Void in
                self.modalViewContainer.hidden = true
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
