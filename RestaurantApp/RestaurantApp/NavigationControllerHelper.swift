//
//  NavigationControllerHelper.swift
//  RestaurantApp
//
//  Created by Rimon on 9/8/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation

class NavigationControllerHelper {
    
    
    static func configureNavigationController(viewController : UIViewController, title : String) {
        
        let navigationBarBackgroundImage = UIImage(named: "navigationBar");
        viewController.navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: .Default)
        viewController.title = NSLocalizedString(title, comment: "")
        viewController.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Vladimir Script", size: 50)!]

    }
}