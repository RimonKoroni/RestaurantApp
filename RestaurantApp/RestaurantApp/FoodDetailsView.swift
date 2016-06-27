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
    var viewCon :UIViewController!
    var nibName: String = "FoodDetailsView"

    @IBOutlet weak var background: UIImageView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    override init(frame: CGRect) {
        // properties
        super.init(frame: frame)
        setup()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        // properties
        super.init(coder: aDecoder)
        setup()
        
        
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