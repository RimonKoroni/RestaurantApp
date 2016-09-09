//
//  AddOrEditFoodTypeViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/8/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit


class AddOrEditFoodTypeViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var arabicTitle: UITextField!
    @IBOutlet weak var turkishTitle: UITextField!
    @IBOutlet weak var englishTitle: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    
    
    var foodType : FoodType?
    var forEditing : Bool!
    var lang : String!
    let imagePicker = UIImagePickerController()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var imageDataService = ImageDataService()
    let foodTypesService = FoodTypesService()
    var uploadNewPhoto : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if foodType != nil {
            NavigationControllerHelper.configureNavigationController(self, title: "addFoodTypeTitle")
        } else {
            NavigationControllerHelper.configureNavigationController(self, title: "editFoodTypeTitle")
        }
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        hideKeyboardWhenTappedAround()
        interfacesDesign()
    }
    
    func interfacesDesign() {
    
        if self.forEditing! {
            self.imageViewContainer.hidden = false
            self.imageStackView.updateConstraints()
            self.confirmButton.setImage(UIImage(named: "editCircleIcon"), forState: .Normal)
            self.arabicTitle.text = self.foodType!.arabicName
            self.englishTitle.text = self.foodType!.englishName
            self.turkishTitle.text = self.foodType!.turkishName
            //let imageData = self.imageDataService.getByUrl(self.foodType!.imageUrl)
            //if imageData == nil {
                self.imageDataService.loadImage(self.foodType!.imageUrl, onComplition: {
                    (data) -> Void in
                    self.imageDataService.insert(self.foodType!.imageUrl, image: data!)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imageView.image = UIImage(data: data!)
                    }
                })
                
            //} else {
            //    self.imageView.image = UIImage(data: imageData!)
            //}
        } else {
            self.confirmButton.setImage(UIImage(named: "addCircleIcon"), forState: .Normal)
            
        }
        self.confirmButton.updateConstraints()
    }
    
    @IBAction func uploadImageAction(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(sender: AnyObject) {

        if self.arabicTitle.text == "" || self.englishTitle.text == "" || self.turkishTitle.text == "" || self.imageView.image == nil {
            self.view.makeToast(message: NSLocalizedString("askToFillFields", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        } else {
            EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
            self.view.userInteractionEnabled = false
            let foodType = generateFoodType()
            let json : JSON = foodType.getJson()
            foodTypesService.addOrEditFoodType(self.forEditing!, json: json, onComplition: { (status) -> Void in
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
                    self.view.makeToast(message: NSLocalizedString("operationFaild", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
                }
            })
            
        }
    }
    
    func generateFoodType() -> FoodType {
        let foodType = FoodType()
        foodType.arabicName = self.arabicTitle.text!.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
        foodType.englishName = self.englishTitle.text!.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
        foodType.turkishName = self.turkishTitle.text!.stringByReplacingOccurrencesOfString("/", withString: "").stringByReplacingOccurrencesOfString("\\", withString: "")
        if self.forEditing! {
            foodType.id = self.foodType!.id
        }
        if self.uploadNewPhoto {
            foodType.imageData = UIImagePNGRepresentation(self.imageView.image!)
        }
        return foodType
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