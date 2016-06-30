//
//  FoodCollectionViewCell.swift
//  RestaurantApp
//
//  Created by SSS on 6/23/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class FoodCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTypeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.foodImage.layer.borderWidth = 2
        self.foodImage.layer.masksToBounds = true
        self.foodImage.layer.cornerRadius = 60
    }
    
}