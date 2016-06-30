//
//  CartCell.swift
//  RestaurantApp
//
//  Created by SSS on 6/30/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class CartCell : UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var count: UILabel!
    var countNumber : Int = 1
    var price : Double!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.foodImage.layer.borderWidth = 2
        price = Double(self.foodPrice.text!.substringToIndex(self.foodPrice.text!.endIndex.predecessor()))
    }
    
    @IBAction func minusAction(sender: AnyObject) {
        if self.countNumber > 1 {
            self.price = self.price / Double(self.countNumber)
            self.countNumber = self.countNumber - 1
            
        }
        self.count.text = String(self.countNumber)
        self.foodPrice.text = String(self.price) + "$"
    }
    
    @IBAction func plusAction(sender: AnyObject) {
        self.countNumber = self.countNumber + 1
        self.price = self.price * Double(self.countNumber)
        self.count.text = String(self.countNumber)
        self.foodPrice.text = String(self.price) + "$"
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        
    }
}