//
//  TableNumberCell.swift
//  RestaurantApp
//
//  Created by Rimon on 9/11/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit


class TableNumberCell: UITableViewCell {
    
    
    @IBOutlet weak var oldNumber: UILabel!
    @IBOutlet weak var newNumber: UITextField!
    
    var delegate : TableNumberDelegate!
    var tableNumber : TableNumber!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func deleteTable(sender: AnyObject) {
        delegate.deleteTableNumber(tableNumber)
    }
    
    
    
}