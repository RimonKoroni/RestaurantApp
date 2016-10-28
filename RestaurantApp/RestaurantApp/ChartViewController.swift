//
//  ChartViewController.swift
//  RestaurantApp
//
//  Created by Rimon on 9/15/16.
//  Copyright © 2016 SSS. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController , PNChartDelegate{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationCount: UILabel!
    @IBOutlet weak var xAxisLabel: UILabel!
    @IBOutlet weak var yAxisLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var centerTime: UILabel!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lang : String!
    var statisticsData : [StatisticsItem]!
    var reportType : Int!
    var xAxis : [String] = []
    var yAxis : [CGFloat] = []
    var fromDate : String!
    var toDate : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationControllerHelper.configureNavigationController(self, title: "statisticsTitle")
        lang = userDefaults.valueForKey("lang") as! String
        addLeftNavItemOnView ()
        fillAxis()
        self.yAxisLabel.transform = CGAffineTransformMakeRotation(-89.55)
        startDate.text = self.fromDate
        endDate.text = self.toDate
    }
    
    override func viewDidAppear(animated: Bool) {
        notificationView.layer.cornerRadius = 15
        self.refreshNotification(self.userDefaults.valueForKey("notification") as! Int)
    }
    
    
    override func viewDidLayoutSubviews() {
        drawChart()
    }
    
    func fillAxis() {
        if reportType == 1 {
            for item in statisticsData {
                xAxis.append(item.key.stringByReplacingOccurrencesOfString("_", withString: "-"))
                yAxis.append(CGFloat(item.value))
            }
        } else {
            statisticsData.sortInPlace({$0.value > $1.value})
            var i = 0
            for item in statisticsData {
                if i < 4 {
                    xAxis.append(item.key)
                    yAxis.append(CGFloat(item.value))
                    i += 1
                } else {
                    break
                }
            }
        }
    }
    
    func drawChart() {
        
        if self.reportType == 1 {
            self.xAxisLabel.hidden = false
            self.yAxisLabel.hidden = false
            if xAxis.count != 1 {
                self.startTime.hidden = false
                self.endTime.hidden = false
                self.centerTime.hidden = false
                self.startTime.text = xAxis[0]
                self.endTime.text = xAxis[xAxis.count - 1]
                if xAxis.count > 2 {
                    self.centerTime.text = xAxis[xAxis.count / 2]
                } else {
                    self.centerTime.hidden = true
                }
            } else {
                self.startTime.hidden = true
                self.endTime.hidden = true
                self.centerTime.hidden = true
            }
            
            let lineChart:PNLineChart = PNLineChart(frame: CGRect(x: 50, y: 50, width: 500, height: 400))
            
            lineChart.backgroundColor = UIColor.clearColor()
            lineChart.xLabels = xAxis
            lineChart.showCoordinateAxis = false
            lineChart.delegate = self
            lineChart.axisWidth = 2
            
            // Line Chart Nr.1
            var data01Array: [CGFloat] = yAxis
            let data01:PNLineChartData = PNLineChartData()
            data01.color = PNGreenColor
            data01.itemCount = data01Array.count
            data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleNone
            data01.getData = ({(index: Int) -> PNLineChartDataItem in
                let yValue:CGFloat = data01Array[index]
                let item = PNLineChartDataItem(y: yValue)
                return item
            })
            lineChart.axisColor = UIColor.brownColor()
            lineChart.chartData = [data01]
            lineChart.strokeChart()
            self.chartView.addSubview(lineChart)
        } else {
            self.xAxisLabel.hidden = true
            self.yAxisLabel.hidden = true
            self.startTime.hidden = true
            self.endTime.hidden = true
            self.centerTime.hidden = true
            let barChart = PNBarChart(frame: CGRect(x: 0, y: 0, width: 600, height: 500))
            barChart.backgroundColor = UIColor.clearColor()
    
            barChart.barBackgroundColor = UIColor.brownColor()
            barChart.barRadius = 10
            barChart.chartMargin = 100
            barChart.labelTextColor = UIColor.whiteColor()
            barChart.labelFont = UIFont(name: "Avenir-Medium", size: 15)!
            barChart.animationType = .Waterfall
            barChart.labelMarginTop = 5.0
            barChart.xLabels = xAxis
            barChart.yValues = yAxis
            barChart.strokeChart()
            barChart.delegate = self
            self.chartView.addSubview(barChart)
        }
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
    
    
    // Overrride PNChart delegate functions
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func userClickedOnBarChartIndex(barIndex: Int)
    {
        print("Click  on bar \(barIndex)")
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
