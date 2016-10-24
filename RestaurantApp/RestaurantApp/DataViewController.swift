//
//  ChartViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/15/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var keyHeader: UILabel!
    @IBOutlet weak var valueHeader: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    var statisticsData : [StatisticsItem]!
    var reportType : Int!
    var dateType : Int!
    var countsSum : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationControllerHelper.configureNavigationController(self, title: "statisticsTitle")
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        
        if reportType == 1 {
            if self.dateType == 1 {
                keyHeader.text = NSLocalizedString("week", comment: "") + " - " +  NSLocalizedString("month", comment: "") + " - " + NSLocalizedString("year", comment: "")
            } else if self.dateType == 2 {
                keyHeader.text = NSLocalizedString("month", comment: "") + " - " + NSLocalizedString("year", comment: "")
            } else {
                keyHeader.text = NSLocalizedString("year", comment: "")
            }
            valueHeader.text = NSLocalizedString("count", comment: "")
        } else if reportType == 2 {
            keyHeader.text = NSLocalizedString("foodName", comment: "")
            valueHeader.text = NSLocalizedString("percentage", comment: "")
            for item in self.statisticsData {
                self.countsSum += item.value
            }
        } else {
            keyHeader.text = NSLocalizedString("foodTypeName", comment: "")
            valueHeader.text = NSLocalizedString("percentage", comment: "")
            for item in self.statisticsData {
                self.countsSum += item.value
            }
        }
        
        statisticsData.sortInPlace({$0.value > $1.value})
        
    }
    
    override func viewDidAppear(animated: Bool) {
        notificationView.layer.cornerRadius = 15
        self.refreshNotification(self.userDefaults.valueForKey("notification") as! Int)
    }
    
    func refreshNotification(count : Int) {
        dispatch_async(dispatch_get_main_queue()) {
            if count == 0 {
                self.notificationView.hidden = true
            } else {
                self.notificationView.hidden = false
                self.notificationCount.text = String(count)
            }
        }
    }
    
    @IBAction func goToHome(sender: AnyObject) {
        let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
        self.presentViewController(adminStartViewController, animated:true, completion:nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statisticsData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dataStatisticsCell") as! DataStatisticsCell
        if lang == "ar" {
            var array = statisticsData[indexPath.row].key.characters.split{$0 == "_"}.map(String.init)
            var key = array[array.count - 1]
            if self.dateType == 1 {
                key += " - " + array[1] + " - " + array[0]
            } else if self.dateType == 2 {
                key += " - " + array[0]
            }
            
            cell.key.text = key
        } else {
            cell.key.text = statisticsData[indexPath.row].key.stringByReplacingOccurrencesOfString("_", withString: " - ")
        }
        if reportType != 1 {
            cell.value.text = String(statisticsData[indexPath.row].value * 100 / self.countsSum) + "%"
        } else {
            cell.value.text = String(statisticsData[indexPath.row].value)
        }
        return cell

    }
    
    
    /**
     The addLeftNavItemOnView function is used for add backe button to the navigation bar.
     */
    func addLeftNavItemOnView () {
        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        // Create the back button
        let buttonBack: UIButton = UIButton(type: UIButtonType.Custom)
        if (self.lang.containsString("ar")) {
            buttonBack.setImage(UIImage(named: "arBackButton"), forState: .Normal)
            
        }
        else {
            buttonBack.setImage(UIImage(named: "enBackButton"), forState: .Normal)
        }
        buttonBack.frame = CGRectMake(0, 0, 40, 40)
        buttonBack.addTarget(self, action: #selector(self.leftNavButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)// Define the action of this button
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)// Create the left bar button
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)// Set the left bar button in the navication
        
    }
    
    /**
     The leftNavButtonClick function is an action which triggered when user press on the backButton.
     */
    func leftNavButtonClick(sender:UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
