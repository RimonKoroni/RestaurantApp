//
//  Labell.swift
//  MMS
//
//  Created by SSS on 6/24/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    public override func awakeFromNib() {
        super.awakeFromNib()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let lang = userDefaults.valueForKey("lang") as! String        
        
        
        if (lang.containsString("ar")) {
            if (self.tag == 1) {
                              let font = UIFontDescriptor.init(name: "Motken daeira", size: self.font.pointSize)
                self.font = UIFont.init(descriptor: font, size: self.font.pointSize)

            }
                    else if(self.tag == 2) {
                let font = UIFontDescriptor.init(name: "Century Gothic", size: self.font.pointSize)
                self.font = UIFont.init(descriptor: font, size: self.font.pointSize)
            
            
            }
                
            else{
                     let font = UIFontDescriptor.init(name: "GE Dinar Two Medium", size: self.font.pointSize)
                self.font = UIFont.init(descriptor: font, size: self.font.pointSize)}
            
            //print (self)
            //print (self.font.familyName)

            
        }
        else {
            if (self.tag == 1) {
            //self.attributedText = NSMutableAttributedString(string: self.text!, attributes: [NSFontAttributeName:UIFont(name: "Century Gothic", size: self.font.pointSize)!])
                let font = UIFontDescriptor.init(name: "Vrinda", size: self.font.pointSize)
                self.font = UIFont.init(descriptor: font, size: self.font.pointSize)
            //print (self)
            //print (self.font.familyName)
            } else {
                let font = UIFontDescriptor.init(name: "Vladimir Script", size: self.font.pointSize)
                self.font = UIFont.init(descriptor: font, size: self.font.pointSize)
            }
            
        }
        
    }
    
   
    }




