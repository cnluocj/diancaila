//
//  OrderConfirmViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/20.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderConfirmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, HttpProtocol, UIPickerViewDataSource, UIPickerViewDelegate, ActionSheetDeletage {
    
    var deskIdView: UITableView!
    var deskIdCell: UITableViewCell!
    var orderListView: UITableView!
    var picker: UIPickerView?
    
    var orderList: [Order]!
    
    let cellHeight =  CGFloat(42)

    var deskId: Int = 1
    var selectDeskid: Int = 1
    
    var numOfDesk: Int = 10
    
    var ehttp: HttpController = HttpController()
    

    override func viewDidLoad() {
        var scrollViewHeight = 44 * CGFloat(orderList.count) + 320
        if scrollViewHeight < UIUtil.screenHeight {
            // 为了当 scrollview没有超出界的时候拖动也有动画效果
            scrollViewHeight = UIUtil.screenHeight+1
        }
        let scrollView = UIScrollView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: UIUtil.screenWidth, height: scrollViewHeight)
        scrollView.scrollEnabled = true
        scrollView.bounces = true
        self.view.addSubview(scrollView)
        
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIUtil.gray_system
        self.title = "下单确认"

        self.deskIdView = UITableView(frame: CGRectMake(0, 40, UIUtil.screenWidth, cellHeight))
        self.deskIdView.delegate = self
        self.deskIdView.dataSource = self
        self.deskIdView.scrollEnabled = false
        scrollView.addSubview(deskIdView)
        
        self.orderListView = UITableView(frame: CGRectMake(0, 130, UIUtil.screenWidth, 44 * CGFloat(orderList.count) - 1))
        self.orderListView.scrollEnabled = false
        self.orderListView.delegate = self
        self.orderListView.dataSource = self
        scrollView.addSubview(orderListView)
        
        
        var heightOffset = CGFloat(0)
        var radius = CGFloat(70)
        if scrollViewHeight > UIUtil.screenHeight {
            heightOffset =  scrollViewHeight - 160
        } else {
            heightOffset = UIUtil.screenHeight - 160
        }
        let okButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2-35, heightOffset, radius, radius))
        okButton.setTitle("下单", forState: UIControlState.Normal)
        okButton.backgroundColor = UIColor.orangeColor()
        okButton.setTitle("松开～", forState: UIControlState.Highlighted)
        okButton.layer.cornerRadius = radius/2
        okButton.addTarget(self, action: "didPressOkButton:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(okButton)
        
        
        
    }
    
    func didPressOkButton(sender: UIButton) {
        self.ehttp.deletage = self
        self.ehttp.onSearch("http://m.weather.com.cn/data/101010100.html")
    }
    
    // test
    func didReceiveResults(result: NSDictionary) {
        
    }
    
    
    // about tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderListView {
            return orderList.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == orderListView {
            let orderCell = "orderCell"
            var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(orderCell)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: orderCell)
            }
            let tempCell = cell as UITableViewCell
            tempCell.textLabel?.text = orderList[indexPath.row].menu.name
            tempCell.detailTextLabel?.text = "\(orderList[indexPath.row].count)份"
            tempCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return tempCell
            
        } else {
            deskIdCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            deskIdCell.textLabel?.text = "桌号"
            if deskId == 0 {
                deskIdCell.detailTextLabel?.text = "请选择桌号"
            } else {
                deskIdCell.detailTextLabel?.text = "\(deskId)号桌"
            }
            deskIdCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return deskIdCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == deskIdView {
//            gotoDeskPickerViewController()
            
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            
            if (picker == nil) {
                picker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
                picker?.delegate = self
                picker?.dataSource = self
            }
            let sheet = CustomActionSheet(customView: picker!)
            sheet.deletage = self
            sheet.show()
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // about picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numOfDesk
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "第\(row+1)桌"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectDeskid = row+1
        
    }
    
    // actionsheet deletage
    func didPressDoneButton() {
        deskId = selectDeskid
        deskIdView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
