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
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    var countNumber : Int = 1
    var price : Double!
    override init(frame: CGRect) {
        // properties
        super.init(frame: frame)
        
        setup()
        
        foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        foodImage.layer.borderWidth = 2
        foodImage.layer.masksToBounds = true
        foodImage.layer.cornerRadius = 5
        price = Double(self.foodPrice.text!.substringToIndex(self.foodPrice.text!.endIndex.predecessor()))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        // properties
        super.init(coder: aDecoder)
        setup()
        
        
    }
    
    
    
    @IBAction func decreaseCount(sender: AnyObject) {
        
        if self.countNumber > 1 {
            self.price = self.price / Double(self.countNumber)
            self.countNumber = self.countNumber - 1
            
        }
        self.count.text = String(self.countNumber)
        self.foodPrice.text = String(self.price) + "$"
    }
    
    @IBAction func increaseCount(sender: AnyObject) {
        self.countNumber = self.countNumber + 1
        self.price = self.price * Double(self.countNumber)
        self.count.text = String(self.countNumber)
        self.foodPrice.text = String(self.price) + "$"
    }
    
    @IBAction func addToCart(sender: AnyObject) {
        
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        lang = userDefaults.valueForKey("lang") as! String
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}