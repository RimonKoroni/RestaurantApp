//
//  foodDetailsView.swift
//  RestaurantApp
//
//  Created by SSS on 6/27/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class FoodDetailsView : UIView {
    var view: UIView!
    
    var nibName: String = "FoodDetailsView"

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var foodTitle: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    var countNumber : Int = 1
    var food : Food!
    var totalPrice : Double!
    init(food: Food, frame: CGRect) {
        super.init(frame: frame)
        setup()
        // properties
        lang = userDefaults.valueForKey("lang") as! String
        foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        foodImage.layer.borderWidth = 2
        foodImage.layer.masksToBounds = true
        foodImage.layer.cornerRadius = 5
        self.foodDescription.text = food.getDescription(lang)
        self.foodTitle.text = food.getName(lang)
        self.foodPrice.text = "\(food.price)$"
        self.food = food
        if let url = NSURL(string: food.imageUrl) {
            if let data = NSData(contentsOfURL: url) {
                self.foodImage.image = UIImage(data: data)
            }
        }
        let imageDataService = ImageDataService()
        let imageData = imageDataService.getByUrl(food.imageUrl)
        
        if imageData == nil {
            imageDataService.loadImage(food.imageUrl, onComplition: {
                (data) -> Void in
                imageDataService.insert(food.imageUrl, image: data)
                dispatch_async(dispatch_get_main_queue()) {
                    self.foodImage.image = UIImage(data: data)
                }
            })
            
        } else {
            self.foodImage.image = UIImage(data: imageData!)
        }

        self.totalPrice = food.price
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        // properties
        super.init(coder: aDecoder)
        setup()
        
        
    }
    
    
    
    @IBAction func decreaseCount(sender: AnyObject) {
        if self.countNumber > 1 {
            self.totalPrice = totalPrice - self.food.price
            self.countNumber = self.countNumber - 1
            self.foodPrice.text = "\(self.totalPrice)$"
            self.count.text = "\(self.countNumber)"
        }
    }
    
    @IBAction func increaseCount(sender: AnyObject) {
        self.totalPrice = totalPrice + self.food.price
        self.countNumber = self.countNumber + 1
        self.foodPrice.text = "\(self.totalPrice)$"
        self.count.text = "\(self.countNumber)"
    }
    
    @IBAction func addToCart(sender: AnyObject) {
        let data = NSUserDefaults.standardUserDefaults().objectForKey("carts") as? NSData
        var carts = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! [Cart]
        let cart = Cart(foodId: self.food.id, count: self.countNumber, foodName: self.food.getName(lang), foodImage : self.food.imageUrl , foodPrice: self.food.price)
        for i in 0..<carts.count {
            if carts[i].foodId == self.food.id {
                carts.removeAtIndex(i)
                break
            }
        }
        carts.append(cart)
        let cartsData = NSKeyedArchiver.archivedDataWithRootObject(carts)
        userDefaults.setObject(cartsData, forKey: "carts")
        userDefaults.synchronize()
        self.makeToast(message: NSLocalizedString("addToCartSuccess", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}