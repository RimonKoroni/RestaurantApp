//
//  ImageView.swift
//  RestaurantApp
//
//  Created by SSS on 7/1/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFit) {
        guard let url = NSURL(string: link) else { return }
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                    let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                    let data = data where error == nil,
                    let image = UIImage(data: data)
                    else { return }
                dispatch_sync(dispatch_get_main_queue(), {
                    self.image = image
                })
        }.resume()
    }
}