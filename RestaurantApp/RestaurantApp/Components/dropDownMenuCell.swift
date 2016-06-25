//
//  dropDownMenuCell.swift
//  RestaurantApp
//
//  Created by SSS on 6/23/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

class dropDownMenuCell: UITableViewCell {
    
    
    @IBOutlet weak var langFlag: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}