//
//  DataStatisticsCell.swift
//  RestaurantApp
//
//  Created by Rimon on 9/19/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit


class DataStatisticsCell: UITableViewCell {
    
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
}
