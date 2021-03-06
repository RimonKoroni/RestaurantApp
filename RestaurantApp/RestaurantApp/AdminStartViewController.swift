//
//  ViewController.swift
//  RestaurantApp
//
//  Created by SSS on 6/22/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

class AdminStartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var langImage: UIImageView!
    @IBOutlet weak var languageTableView: UITableView!
    
    let notificationService = NotificationService()
    var languages : [String]!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")// Info.pList path
        let dict: AnyObject = NSDictionary(contentsOfFile: path!)!// Dictionary for "info.pList" properties
        let schedualTime = dict.valueForKey("checkForNotificationTime") as! Double
        NSTimer.scheduledTimerWithTimeInterval(schedualTime, target: self.notificationService, selector: #selector(self.notificationService.checkForNewOrders), userInfo: nil, repeats: true)
        lang = userDefaults.valueForKey("lang") as! String
        languages = ["US", "TR", "AR"]
        
        if lang.containsString("en") {
            self.languageButton.setTitle(languages[0], forState: .Normal)
            self.langImage.image = UIImage(named: languages[0])
        } else if lang.containsString("ar") {
            self.languageButton.setTitle(languages[2], forState: .Normal)
            self.langImage.image = UIImage(named: languages[2])
        } else {
            self.languageButton.setTitle(languages[1], forState: .Normal)
            self.langImage.image = UIImage(named: languages[1])
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.languageTableView.layer.cornerRadius = 10
    }
    
    
    @IBAction func changeLang(sender: AnyObject) {
        self.languageTableView.hidden = false
        self.languageTableView.alpha = 0
        UIView.animateWithDuration(0.7, delay: 0.1, options: .CurveEaseOut, animations: {
            self.languageTableView.alpha = 1
            }, completion: { (finished:Bool) in
                
        })
    }
    

    @IBAction func startButton(sender: AnyObject) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! dropDownMenuCell
        cell.label.text = languages[indexPath.row]
        cell.langFlag.image = UIImage(named: languages[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.languageButton.setTitle(languages[indexPath.row], forState: .Normal)
        self.langImage.image = UIImage(named: languages[indexPath.row])
        self.languageTableView.alpha = 1
        UIView.animateWithDuration(0.7, delay: 0.1, options: .CurveEaseOut, animations: {
            self.languageTableView.alpha = 0
            var langCode = ""
            if indexPath.row == 0 {
                langCode = "en"
            } else if indexPath.row == 1 {
                langCode = "tr"
            } else {
                langCode = "ar"
            }
            
            NSUserDefaults.standardUserDefaults().setObject([langCode], forKey: "AppleLanguages")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.userDefaults.setValue(langCode, forKey: "lang")
            
            
            let alertController = UIAlertController(title: NSLocalizedString("changeLanguageTitle", comment: ""), message: NSLocalizedString("changeLanguageMsg", comment: ""), preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                exit(0)
            }
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            }, completion: { (finished:Bool) in
                self.languageTableView.hidden = true
        })
    }
    
}

