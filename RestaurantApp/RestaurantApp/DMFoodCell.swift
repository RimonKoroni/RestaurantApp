//
//  DMFoodCell.swift
//  RestaurantApp
//
//  Created by Rimon on 9/10/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class DMFoodCell: UITableViewCell {
    
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var food : Food!
    var delegate : FoodProtocol!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.foodImage.layer.borderWidth = 2
    }
    
    @IBAction func editFood(sender: AnyObject) {
        delegate.editFood(food)
    }
    
    @IBAction func deleteFood(sender: AnyObject) {
        delegate.deleteFood(food)
    }
}