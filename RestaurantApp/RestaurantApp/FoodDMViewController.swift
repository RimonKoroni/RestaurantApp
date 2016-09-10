//
//  File.swift
//  RestaurantApp
//
//  Created by Rimon on 9/8/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

protocol FoodProtocol {
    func deleteFood(food : Food)
    func editFood(food : Food)
}

class FoodDMViewController : UIViewController, FoodProtocol {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFoodLable: UILabel!
    @IBOutlet weak var deleteConfirmationLabel: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var foods : [Food] = []
    var lang : String!
    var foodService = FoodService()
    var generalService = GeneralService()
    var imageDataService = ImageDataService()
    var selectedFood : Food!
    var selectForEdit : Bool = false
    var foodType : FoodType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = userDefaults.valueForKey("lang") as! String
        NavigationControllerHelper.configureNavigationController(self, title: self.foodType!.getName(lang))
        addLeftNavItemOnView ()
        self.noFoodLable.text = NSLocalizedString("noFoodMessage", comment: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        getFoods()
        self.tableView.reloadData()
    }
    
    
    func getFoods() {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        
        foodService.getFoods(self.foodType!.id, forEditing: 1, onComplition: {
            (result) -> Void in
            self.foods = result
            dispatch_sync(dispatch_get_main_queue(), {
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
        return self.foods.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DMFoodCell") as! DMFoodCell
        
        cell.delegate = self
        cell.name.text = self.foods[indexPath.row].getName(lang)
        let imageData = self.foods[indexPath.row].imageData
        if imageData == nil {
            self.imageDataService.loadImage(self.foods[indexPath.row].imageUrl, onComplition: {
                (data) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        //self.imageDataService.insert(self.foodTypes[indexPath.row].imageUrl, image: data!)
                        cell.foodImage.image = UIImage(data: data!)
                        self.foods[indexPath.row].imageData = data
                    } else {
                        cell.foodImage.image = UIImage(named: "emptyImage")
                    }
                }
            })
            
        } else {
            cell.foodImage.image = UIImage(data: imageData!)
        }
        cell.food = self.foods[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.selectedOrderId = orders[indexPath.row].id
        //self.performSegueWithIdentifier("goToOrderViewControllerSegue", sender: self)
        
    }
    
    @IBAction func addFoodAction(sender: AnyObject) {
        self.selectForEdit = false
        performSegueWithIdentifier("addOrEditFoodSegue", sender: sender)
    }
    
    // Overwrite FoodProtocol functions
    
    func deleteFood(food : Food) {
        self.selectedFood = food
        self.deleteConfirmationLabel.text = NSLocalizedString("deleteMessage", comment: "") + food.getName(self.lang)! + "?"
        showModal()
    }
    
    func editFood(food: Food) {
        self.selectForEdit = true
        self.selectedFood = food
        performSegueWithIdentifier("addOrEditFoodSegue", sender: self)
    }
    
    
    @IBAction func acceptDeleteAction(sender: AnyObject) {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        foodService.deleteFood(self.selectedFood.id, onComplition: {(status: Int) -> Void in
            if status == 1 {
                //self.imageDataService.delete(self.selectedFoodType.imageUrl)
                self.view.makeToast(message: NSLocalizedString("deletedSuccessfully", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                self.getFoods()
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addOrEditFoodSegue" {
            let controller = segue.destinationViewController as! addOrEditFoodViewController
            controller.foodType = self.foodType
            if self.selectForEdit {
                controller.food = self.selectedFood
                controller.forEditing = true
            } else {
                controller.forEditing = false
            }
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