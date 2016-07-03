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
    var cart : Cart!
    var countNumber : Int = 1
    var price : Double!
    var totalPrice : Double = 0
    var delegate : CartDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.foodImage.layer.borderWidth = 2
    }
    
    @IBAction func minusAction(sender: AnyObject) {
        if self.countNumber > 1 {
            self.totalPrice = totalPrice - self.cart.foodPrice
            self.countNumber = self.countNumber - 1
            self.foodPrice.text = "\(self.totalPrice)$"
            self.count.text = "\(self.countNumber)"
            self.delegate.calculatePrice(-1 * self.cart.foodPrice)
        }
    }
    
    @IBAction func plusAction(sender: AnyObject) {
        self.totalPrice = totalPrice + self.cart.foodPrice
        self.countNumber = self.countNumber + 1
        self.foodPrice.text = "\(self.totalPrice)$"
        self.count.text = "\(self.countNumber)"
        self.delegate.calculatePrice(self.cart.foodPrice)
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        self.delegate.deleteCart(self.cart)
    }
}