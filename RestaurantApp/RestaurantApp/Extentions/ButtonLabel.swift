//
//  ButtonLabel.swift
//  MMS
//
//  Created by SSS on 6/24/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit
extension UIButton{
    

    
public override func awakeFromNib() {
    super.awakeFromNib()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let lang = userDefaults.valueForKey("lang") as! String
    
    
    
    if (lang.containsString("ar")){
//        self.setAttributedTitle(NSMutableAttributedString(string: self.titleLabel!.text!, attributes: [NSFontAttributeName:UIFont(name: "Motken daeira", size: self.titleLabel!.font.pointSize)!]), forState: .Normal)
        if (self.tag == 1) {

        let font = UIFontDescriptor.init(name: "Motken daeira", size: (self.titleLabel?.font.pointSize)!)
            self.titleLabel!.font = UIFont.init(descriptor: font, size: (self.titleLabel?.font.pointSize)!)}
        else
                {
                    let font = UIFontDescriptor.init(name: "GE Dinar Two Medium", size: (self.titleLabel?.font.pointSize)!)
                    self.titleLabel!.font = UIFont.init(descriptor: font, size: (self.titleLabel?.font.pointSize)!)
        
                        }
        //print (self)
        //print (self.titleLabel!.font.familyName)
        
        
    }
    else {
        if (self.tag == 1) {
            
            let font = UIFontDescriptor.init(name: "Vrinda", size: (self.titleLabel?.font.pointSize)!)
            self.titleLabel?.font = UIFont.init(descriptor: font, size: (self.titleLabel?.font.pointSize)!)
            //print (self)
            //print (self.font.familyName)
        } else {
            let font = UIFontDescriptor.init(name: "Vladimir Script", size: (self.titleLabel?.font.pointSize)!)
            self.titleLabel?.font = UIFont.init(descriptor: font, size: (self.titleLabel?.font.pointSize)!)
        }
        
        //print (self)
        //print (self.titleLabel!.font.familyName)
        
    }
    
}


}

