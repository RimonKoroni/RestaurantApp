//
//  DMFoodTypeCell.swift
//  RestaurantApp
//
//  Created by Rimon on 9/5/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit


class DMFoodTypeCell: UITableViewCell {
    
    
    @IBOutlet weak var foodTypeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var foodType : FoodType!
    var delegate : FoodTypeProtocol!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodTypeImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.foodTypeImage.layer.borderWidth = 2
    }
    
    @IBAction func editFoodType(sender: AnyObject) {
        delegate.editFoodType(foodType)
    }

    @IBAction func addFoodToFoodType(sender: AnyObject) {
        delegate.addFoodToFoodType(foodType)
    }
    
    @IBAction func deleteFoodType(sender: AnyObject) {
        delegate.deleteFoodType(foodType)
    }
}
