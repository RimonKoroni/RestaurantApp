//
//  addOrEditFoodViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/10/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

class addOrEditFoodViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var arabicTitle: UITextField!
    @IBOutlet weak var turkishTitle: UITextField!
    @IBOutlet weak var englishTitle: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var arabicDescription: UITextView!
    @IBOutlet weak var englishDescription: UITextView!
    @IBOutlet weak var turkishDescription: UITextView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var isValidButton: UIButton!
    
    var foodType : FoodType!
    var food : Food?
    var forEditing : Bool!
    var lang : String!
    let imagePicker = UIImagePickerController()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var imageDataService = ImageDataService()
    let foodService = FoodService()
    var uploadNewPhoto : Bool = false
    var placeHolderColor : UIColor!
    var isValid : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        if food != nil {
            NavigationControllerHelper.configureNavigationController(self, title: "addFoodTitle")
        } else {
            NavigationControllerHelper.configureNavigationController(self, title: "editFoodTitle")
        }
        lang = userDefaults.valueForKey("lang") as! String
        placeHolderColor = UIColor.brownColor().colorWithAlphaComponent(60)
        addLeftNavItemOnView ()
        hideKeyboardWhenTappedAround()
        interfacesDesign()
    }
    
    func interfacesDesign() {
        
        if self.forEditing! {
            self.imageViewContainer.hidden = false
            self.imageStackView.updateConstraints()
            self.confirmButton.setImage(UIImage(named: "editCircleIcon"), forState: .Normal)
            self.arabicTitle.text = self.food!.arabicName
            self.englishTitle.text = self.food!.englishName
            self.turkishTitle.text = self.food!.turkishName
            if self.food!.arabicDescription != nil {
                self.arabicDescription.text = self.food!.arabicDescription
            } else {
                self.arabicDescription.text = NSLocalizedString("arabicDescription", comment: "")
                self.arabicDescription.textColor = self.placeHolderColor
            }
            if self.food!.englishDescription != nil {
                self.englishDescription.text = self.food!.englishDescription
            } else {
                self.englishDescription.text = NSLocalizedString("englishDescription", comment: "")
                self.englishDescription.textColor = self.placeHolderColor
            }
            if self.food!.turkishDescription != nil {
                self.turkishDescription.text = self.food!.turkishDescription
            } else {
                self.turkishDescription.text = NSLocalizedString("turkishDescription", comment: "")
                self.turkishDescription.textColor = self.placeHolderColor
            }
            self.price.text = "\(self.food!.price)"
            if self.food?.isValid == 1 {
                self.isValidButton.setImage(UIImage(named: "check"), forState: .Normal)
            } else {
                self.isValidButton.setImage(UIImage(named: "unCheck"), forState: .Normal)
            }
            //let imageData = self.imageDataService.getByUrl(self.foodType!.imageUrl)
            //if imageData == nil {
            self.imageDataService.loadImage(self.food!.imageUrl, onComplition: {
                (data) -> Void in
                //self.imageDataService.insert(self.foodType!.imageUrl, image: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        //self.imageDataService.insert(self.foodTypes[indexPath.row].imageUrl, image: data!)
                        self.imageView.image = UIImage(data: data!)
                    } else {
                        self.imageView.image = UIImage(named: "emptyImage")
                    }
                }
            })
            
            //} else {
            //    self.imageView.image = UIImage(data: imageData!)
            //}
        } else {
            self.confirmButton.setImage(UIImage(named: "addCircleIcon"), forState: .Normal)
            
            self.arabicDescription.text = NSLocalizedString("arabicDescription", comment: "")
            self.arabicDescription.textColor = self.placeHolderColor
       
            self.englishDescription.text = NSLocalizedString("englishDescription", comment: "")
            self.englishDescription.textColor = self.placeHolderColor
        
            self.turkishDescription.text = NSLocalizedString("turkishDescription", comment: "")
            self.turkishDescription.textColor = self.placeHolderColor
        }
        self.confirmButton.updateConstraints()
        notificationView.layer.cornerRadius = 15
        self.refreshNotification(self.userDefaults.valueForKey("notification") as! Int)
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
    
    @IBAction func uploadImageAction(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        if self.arabicTitle.text == "" || self.englishTitle.text == "" || self.turkishTitle.text == "" || self.imageView.image == nil || self.price.text == "" {
            self.view.makeToast(message: NSLocalizedString("askToFillFields", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        } else if self.price.text!.doubleValue == nil {
            self.view.makeToast(message: NSLocalizedString("priceValidationError", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        } else {
            EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
            self.view.userInteractionEnabled = false
            let food = generateFood()
            let json : JSON = food.getJson()
            foodService.addOrEditFood(self.foodType.id, forEditing: self.forEditing!, json: json, onComplition: { (status) -> Void in
                if status == 1 {
                    self.navigationController?.popViewControllerAnimated(true)
                    let controller = self.navigationController?.topViewController
                    dispatch_sync(dispatch_get_main_queue(), {
                        if self.forEditing! {
                            //                            if self.uploadNewPhoto {
                            //                                self.imageDataService.delete(self.foodType!.imageUrl)
                            //                            }
                            controller!.view.makeToast(message: NSLocalizedString("editedSuccessfully", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                        } else {
                            controller!.view.makeToast(message: NSLocalizedString("addedSuccessfully", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                        }
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
    
    func generateFood() -> Food {
        let food = Food()
        food.arabicName = self.arabicTitle.text!.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
        food.englishName = self.englishTitle.text!.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
        food.turkishName = self.turkishTitle.text!.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
        if self.arabicDescription.text != NSLocalizedString("arabicDescription", comment: "") {
            food.arabicDescription = self.arabicDescription.text
        }
        if self.englishDescription.text != NSLocalizedString("englishDescription", comment: "") {
            food.englishDescription = self.englishDescription.text
        }
        if self.turkishDescription.text != NSLocalizedString("turkishDescription", comment: "") {
            food.turkishDescription = self.turkishDescription.text
        }
        food.price = Double(self.price.text!)
        if self.isValid {
            food.isValid = 1
        } else {
            food.isValid = 0
        }
        if self.forEditing! {
            food.id = self.food!.id
        }
        if self.uploadNewPhoto {
            food.imageData = UIImagePNGRepresentation(self.imageView.image!)
        }
        return food
    }
    
    // UIImagePickerControllerDelegate delegation functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            imageViewContainer.hidden = false
            imageStackView.updateConstraints()
            uploadNewPhoto = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func isValidAction(sender: UIButton) {
        if self.isValid {
            self.isValid = false
            sender.setImage(UIImage(named: "unCheck"), forState: .Normal)
        } else {
            self.isValid = true
            sender.setImage(UIImage(named: "check"), forState: .Normal)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            if textView.tag == 1{
                textView.text = NSLocalizedString("arabicDescription", comment: "")
            }
            else if textView.tag == 2 {
                textView.text = NSLocalizedString("englishDescription", comment: "")
            } else {
                textView.text = NSLocalizedString("turkishDescription", comment: "")
            }
            textView.textAlignment = .Center
            textView.textColor = self.placeHolderColor
        }
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.textAlignment = NSTextAlignment.Natural
        if textView.textColor == self.placeHolderColor {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
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