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