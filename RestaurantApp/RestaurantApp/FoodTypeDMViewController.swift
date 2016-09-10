//
//  FoodTypeDMViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/6/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

protocol FoodTypeProtocol {
    func deleteFoodType(foodType : FoodType)
    func editFoodType(foodType : FoodType)
    func addFoodToFoodType(foodType : FoodType)
}

class FoodTypeDMViewController: UIViewController , FoodTypeProtocol {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFoodTypeLable: UILabel!
    @IBOutlet weak var deleteConfirmationLabel: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var foodTypes : [FoodType] = []
    var lang : String!
    var foodTypeService = FoodTypesService()
    var generalService = GeneralService()
    var imageDataService = ImageDataService()
    var selectedFoodType : FoodType!
    var selectForEdit : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationControllerHelper.configureNavigationController(self, title: "dataManagementTitle")
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        self.noFoodTypeLable.text = NSLocalizedString("noFoodTypesMessage", comment: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        getFoodTypes()
        self.tableView.reloadData()
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
    
    func getFoodTypes() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        foodTypeService.getAllFoodTypes({
            (result) -> Void in
            self.foodTypes = result
            dispatch_sync(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
            })
        })
    }
 
    
    @IBAction func goToHome(sender: AnyObject) {
        let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
        self.presentViewController(adminStartViewController, animated:true, completion:nil)
    }
    
    @IBAction func goToNotification(sender: AnyObject) {
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DMFoodTypeCell") as! DMFoodTypeCell
        
        cell.delegate = self
        cell.name.text = self.foodTypes[indexPath.row].getName(lang)
        let imageData = self.foodTypes[indexPath.row].imageData
        if imageData == nil {
            self.imageDataService.loadImage(self.foodTypes[indexPath.row].imageUrl, onComplition: {
                (data) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        //self.imageDataService.insert(self.foodTypes[indexPath.row].imageUrl, image: data!)
                        cell.foodTypeImage.image = UIImage(data: data!)
                        self.foodTypes[indexPath.row].imageData = data
                    } else {
                        cell.foodTypeImage.image = UIImage(named: "emptyImage")
                    }
                }
            })
            
        } else {
          cell.foodTypeImage.image = UIImage(data: imageData!)
        }
        cell.foodType = self.foodTypes[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.selectedOrderId = orders[indexPath.row].id
        //self.performSegueWithIdentifier("goToOrderViewControllerSegue", sender: self)
        
    }
    

    @IBAction func addFoodTypeAction(sender: AnyObject) {
        self.selectForEdit = false
        performSegueWithIdentifier("addOrEditFoodTypeSegue", sender: sender)
    }
    
    
    // Overwrite FoodTypeProtocol functions
    
    func deleteFoodType(foodType : FoodType) {
        self.selectedFoodType = foodType
        self.deleteConfirmationLabel.text = NSLocalizedString("deleteMessage", comment: "") + foodType.getName(self.lang) + "?"
        showModal()
    }
    
    func editFoodType(foodType: FoodType) {
        self.selectForEdit = true
        self.selectedFoodType = foodType
        performSegueWithIdentifier("addOrEditFoodTypeSegue", sender: self)
    }
    
    @IBAction func acceptDeleteAction(sender: AnyObject) {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        foodTypeService.deleteFoodType(self.selectedFoodType.id, onComplition: {(status: Int) -> Void in
            if status == 1 {
                //self.imageDataService.delete(self.selectedFoodType.imageUrl)
                self.view.makeToast(message: NSLocalizedString("deletedSuccessfully", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                self.getFoodTypes()
                dispatch_sync(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    EZLoadingActivity.hide()
                    self.view.userInteractionEnabled = true
                    self.hideModal()
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
    
    
    func addFoodToFoodType(foodType: FoodType) {
        self.selectedFoodType = foodType
        performSegueWithIdentifier("showFoodsSegue", sender: self)
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addOrEditFoodTypeSegue" {
            let controller = segue.destinationViewController as! AddOrEditFoodTypeViewController
            if self.selectForEdit {
                controller.foodType = self.selectedFoodType
                controller.forEditing = true
            } else {
                controller.forEditing = false
            }
        }
        
        if segue.identifier == "showFoodsSegue" {
            let controller = segue.destinationViewController as! FoodDMViewController
            controller.foodType = self.selectedFoodType
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
