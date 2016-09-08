//
//  UIViewControllerExtention.swift
//  RestaurantApp
//
//  Created by Rimon on 9/8/16.
//  Copyright © 2016 SSS. All rights reserved.
//

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}