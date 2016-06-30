//
//  CartCell.swift
//  RestaurantApp
//
//  Created by SSS on 6/30/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class OrderCell : UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var foodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.foodImage.layer.borderWidth = 2
    }
    
}