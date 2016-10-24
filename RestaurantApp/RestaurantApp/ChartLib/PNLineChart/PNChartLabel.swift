//
//  PNChartLabel.swift
//  PNChart-Swift
//
//  Created by kevinzhow on 6/4/14.
//  Copyright (c) 2014 Catch Inc. All rights reserved.
//

import UIKit

class PNChartLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.boldSystemFontOfSize(5.0)
        textColor = UIColor.whiteColor()
        backgroundColor = UIColor.clearColor()
        textAlignment = NSTextAlignment.Center
        userInteractionEnabled = true
        //transform = CGAffineTransformMakeRotation(45)
        lineBreakMode = .ByWordWrapping
        numberOfLines = 0
        //transform = CGAffineTransformMakeScale(-1, 1);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
