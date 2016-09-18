//
//  StatisticsViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/14/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit


class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var reportTypeButton: UIButton!
    @IBOutlet weak var dateTypeButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reportTypeDropDownList: UIView!
    @IBOutlet weak var reportTypeTableView: UITableView!
    @IBOutlet weak var perDropDownList: UIView!
    @IBOutlet weak var perTableView: UITableView!
    @IBOutlet weak var reportTypeDropDownListIcon: UIImageView!
    @IBOutlet weak var dateTypeDropDownListIcon: UIImageView!
    @IBOutlet weak var dateTypeView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    var reportTypes : [String] = []
    var dateTypes : [String] = []
    var reportTypeListShown : Bool = false
    var dateTypeListShown : Bool = false
    var isFromDate : Bool = true
    var fromDateString : String?
    var toDateString : String?
    var selectedReportType : Int = 1
    var selectedDateType : Int = 1
    var statisticsItems : [StatisticsItem] = []
    var statisticsService = StatisticsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = userDefaults.valueForKey("lang") as! String
        NavigationControllerHelper.configureNavigationController(self, title: NSLocalizedString("statisticsTitle", comment: ""))
        addLeftNavItemOnView ()
        fillTables()
        self.datePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        self.datePicker.setDate(NSDate(), animated: false)
        
    }
    
    func fillTables() {
        self.reportTypes = [NSLocalizedString("clientRequest", comment: ""), NSLocalizedString("bestFoodType", comment: ""), NSLocalizedString("bestFood", comment: "")]
        self.dateTypes = [NSLocalizedString("week", comment: ""), NSLocalizedString("month", comment: ""), NSLocalizedString("year", comment: "")]
    }
    
    @IBAction func reportTypeButtonAction(sender: AnyObject) {
        hideDropDownList(self.perDropDownList)
        if reportTypeListShown {
            hideDropDownList(self.reportTypeDropDownList)
        } else {
            showDropDownList(self.reportTypeDropDownList)
        }
    }
    
    @IBAction func dateTypeButtonAction(sender: AnyObject) {
        hideDropDownList(self.reportTypeDropDownList)
        if dateTypeListShown {
            hideDropDownList(self.perDropDownList)
        } else {
            showDropDownList(self.perDropDownList)
        }
    }
    
    @IBAction func fromDateButtonAction(sender: AnyObject) {
        isFromDate = true
        hideDropDownList(self.reportTypeDropDownList)
        hideDropDownList(self.perDropDownList)
        showModal()
    }
    
    @IBAction func toDateButtonAction(sender: AnyObject) {
        isFromDate = false
        hideDropDownList(self.reportTypeDropDownList)
        hideDropDownList(self.perDropDownList)
        showModal()
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
    
    @IBAction func selectDate(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(self.datePicker.date)
        
        if(self.isFromDate){
            self.fromDateButton.setTitle(date, forState: .Normal)
            self.fromDateString = date
        }
        else {
            self.toDateButton.setTitle(date, forState: .Normal)
            self.toDateString = date
        }
        hideModal()
    }
    
    
    @IBAction func cancelDateModel(sender: AnyObject) {
        hideModal()
    }
    
    func showDropDownList(dropDownView : UIView) {
        dropDownView.alpha = 0
        dropDownView.hidden = false
        if dropDownView == self.reportTypeDropDownList {
            self.reportTypeDropDownListIcon.image = UIImage(named: "dropDownIconUP")
            self.reportTypeListShown = true
        } else {
            self.dateTypeDropDownListIcon.image = UIImage(named: "dropDownIconUP")
            self.dateTypeListShown = true
        }
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            dropDownView.alpha = 1
            
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func hideDropDownList(dropDownView : UIView) {
        dropDownView.alpha = 1
        if dropDownView == self.reportTypeDropDownList {
            self.reportTypeDropDownListIcon.image = UIImage(named: "dropDownIconDown")
            self.reportTypeListShown = false
        } else {
            self.dateTypeDropDownListIcon.image = UIImage(named: "dropDownIconDown")
            self.dateTypeListShown = false
        }
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            dropDownView.alpha = 0
            
            }, completion: { (finished: Bool) -> Void in
                dropDownView.hidden = true
        })
    }
    
    
    func showModal() {
        self.modalViewContainer.alpha = 0
        self.modalViewContainer.hidden = false
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.modalViewContainer.alpha = 1
            
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func getStatistics(segueId : String) {
        EZLoadingActivity.show(NSLocalizedString("loading", comment: ""), disableUI: false)
        self.view.userInteractionEnabled = false
        statisticsService.getStatisticData(self.selectedReportType, dateType: self.selectedDateType, fromDate: self.fromDateString!, toDate: self.toDateString!, lang: self.lang, onComplition: {
            (statisticsItems) -> Void in
            self.statisticsItems = statisticsItems
            dispatch_sync(dispatch_get_main_queue(), {
                EZLoadingActivity.hide()
                self.view.userInteractionEnabled = true
                self.performSegueWithIdentifier(segueId, sender: self)
            })
        })

    }
    
    
    @IBAction func showChart(sender: AnyObject) {
        if self.fromDateString == nil || self.toDateString == nil {
            self.view.makeToast(message: NSLocalizedString("askToFillFields", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        } else {
            getStatistics("showChartSegue")
        }
    }
    
    @IBAction func showData(sender: AnyObject) {
        if self.fromDateString == nil || self.toDateString == nil {
            self.view.makeToast(message: NSLocalizedString("askToFillFields", comment: ""), duration: HRToastDefaultDuration, position: HRToastPositionTop)
        } else {
            getStatistics("showDataSegue")
        }
    }
    
    func hideModal() {
        self.modalViewContainer.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.modalViewContainer.alpha = 0
            
            }, completion: { (finished: Bool) -> Void in
                self.modalViewContainer.hidden = true
        })
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.reportTypeTableView {
            self.reportTypes.count
        }
        
        if tableView == self.perTableView {
            return self.dateTypes.count
        }
        
        return 3
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("normalCell", forIndexPath: indexPath) as! NormalCell
        cell.backgroundColor = UIColor.clearColor()
        
        if tableView == self.reportTypeTableView {
            cell.label.text = self.reportTypes[indexPath.row]
        }
        
        if tableView == self.perTableView {
            cell.label.text = self.dateTypes[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.reportTypeTableView {
            self.reportTypeButton.setTitle(self.reportTypes[indexPath.row], forState: .Normal)
            self.hideDropDownList(self.reportTypeDropDownList)
            self.selectedReportType = indexPath.row + 1
            if indexPath.row != 0 {
                self.dateTypeView.hidden = true
                stackView.updateConstraints()
                
            } else {
                self.dateTypeView.hidden = false
                stackView.updateConstraints()
            }
        }
        
        if tableView == self.perTableView {
            self.dateTypeButton.setTitle(self.dateTypes[indexPath.row], forState: .Normal)
            self.hideDropDownList(self.perDropDownList)
            self.selectedDateType = indexPath.row + 1
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChartSegue" {
            let viewController = segue.destinationViewController as! ChartViewController
            viewController.statisticsData = self.statisticsItems
        }
        
        if segue.identifier == "showDataSegue" {
            let viewController = segue.destinationViewController as! DataViewController
            viewController.statisticsData = self.statisticsItems
        }
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
        if self.navigationController?.viewControllers.count > 1 {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let adminStartViewController = storyboard!.instantiateViewControllerWithIdentifier("AdminStartViewController") as! AdminStartViewController
            self.presentViewController(adminStartViewController, animated:true, completion:nil)
        }
    }
}
