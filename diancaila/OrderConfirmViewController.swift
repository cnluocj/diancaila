//
//  OrderConfirmViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/20.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderConfirmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ActionSheetDeletage {
    
    var deskInfoView: UITableView!
    var deskInfoCell: UITableViewCell!
    var orderListView: UITableView!
    var deskIdPicker: UIPickerView?
    var customerNumPicker: UIPickerView?
    var alertLabel: UILabel!
    var okButton: UIButton!
    
    // 值由外面一层传入
    var orderList: [Order]!
    
    let cellHeight =  CGFloat(42)

    var shopId: Int = 2
    
    // 桌号
    var deskId: Int = 0
    var selectDeskid: Int = 1
    var numOfDesk: Int = 10
    
    // 人数
    var customerNum: Int = 0
    var selectCustomerNum: Int = 1
    var maxNumOfCustom: Int = 50
    
    // jsonDic
    var jsonDic = NSMutableDictionary()
    
    var ehttp: HttpController = HttpController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scrollViewHeight = cellHeight * CGFloat(orderList.count) + 350
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
        
        
        
        self.view.backgroundColor = UIUtil.gray_system
        self.title = "下单确认"

        self.deskInfoView = UITableView(frame: CGRectMake(0, 40, UIUtil.screenWidth, cellHeight*2))
        self.deskInfoView.delegate = self
        self.deskInfoView.dataSource = self
        self.deskInfoView.scrollEnabled = false
        scrollView.addSubview(deskInfoView)
        
        self.orderListView = UITableView(frame: CGRectMake(0, 130 + cellHeight, UIUtil.screenWidth, 44 * CGFloat(orderList.count) - 1))
        self.orderListView.scrollEnabled = false
        self.orderListView.delegate = self
        self.orderListView.dataSource = self
        scrollView.addSubview(orderListView)
        
        
        // 下方偏移量
        var heightOffset = CGFloat(0)
        var radius = CGFloat(70)
        if scrollViewHeight > UIUtil.screenHeight + 1 {
            heightOffset =  scrollViewHeight - 150
        } else {
            heightOffset = UIUtil.screenHeight - 160
        }
        
        // 下单按钮

        okButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2-35, heightOffset, radius, radius))
        okButton.setTitle("下单", forState: UIControlState.Normal)
        okButton.backgroundColor = UIColor.orangeColor()
        okButton.setTitle("松开～", forState: UIControlState.Highlighted)
        okButton.layer.cornerRadius = radius/2
        okButton.addTarget(self, action: "didPressOkButton:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(okButton)
        
        
        
    }
    
    func didPressOkButton(sender: UIButton) {
        
        if deskId == 0 {
            okButton.setTitle("没桌号", forState: UIControlState.Normal)
            okButton.backgroundColor = UIColor.redColor()
            okButtonShake()
            
        } else if customerNum == 0 {
            okButton.setTitle("没人数", forState: UIControlState.Normal)
            okButton.backgroundColor = UIColor.redColor()
            okButtonShake()
            
        } else if customerNum == 0 {
        } else {
        
            jsonDic["shop_id"] = shopId
            jsonDic["tab_id"] = deskId
            jsonDic["cus_num"] = customerNum
            jsonDic["card_id"] = 0
            
            var dishList = NSMutableArray()
            
            for order in orderList {
                var dish: NSMutableDictionary = NSMutableDictionary()
                
                dish["dish_id"] = order.menu.id
                dish["dish_num"] = order.count
                
                dishList.addObject(dish)
            }
            
            jsonDic["dish_list"] = dishList
            
            var data = NSJSONSerialization.dataWithJSONObject(jsonDic, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            var jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
            jsonStr = jsonStr?.stringByReplacingOccurrencesOfString("\n", withString: "")
            jsonStr = jsonStr?.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            println("\(jsonStr?.description)")
            ehttp.submitOrder(HttpController.submitOrderAPI, json: jsonStr!)
        }
    }
    
    func okButtonShake() {
        let moveLeft = CGAffineTransformMakeTranslation(-20, 0)
        let moveRight = CGAffineTransformMakeTranslation(20, 0)
        let resetTransform = CGAffineTransformMakeTranslation(0, 0)
        
        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
            self.okButton.transform = moveLeft
            
            }) { (finished: Bool) -> Void in
                
                if finished {
                    UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                        self.okButton.transform = moveRight
                        
                        }, completion: { (finished: Bool) -> Void in
                            
                            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                                
                                self.okButton.transform = resetTransform
                                }, completion: { (finished: Bool) -> Void in
                            })
                    })
                }
        }
    }
    
    // about tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == orderListView {
            return orderList.count
        } else {
            return 2
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
            
            deskInfoCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            
            if indexPath.row == 0 {
                deskInfoCell.textLabel?.text = "桌号"
                if deskId == 0 {
                    deskInfoCell.detailTextLabel?.text = "请选择桌号"
                } else {
                    deskInfoCell.detailTextLabel?.text = "\(deskId)号桌"
                }
                deskInfoCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return deskInfoCell
                
            } else {
                deskInfoCell.textLabel?.text = "人数"
                if customerNum == 0 {
                    deskInfoCell.detailTextLabel?.text = "请选择人数"
                } else {
                    deskInfoCell.detailTextLabel?.text = "\(customerNum)人"
                }
                deskInfoCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return deskInfoCell
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == deskInfoView {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            
            
            if indexPath.row == 0 {
                if (deskIdPicker == nil) {
                    deskIdPicker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
                    deskIdPicker?.delegate = self
                    deskIdPicker?.dataSource = self
                    deskIdPicker?.selectRow(numOfDesk, inComponent: 0, animated: true)
                }
                let sheet = CustomActionSheet(customView: deskIdPicker!)
                sheet.deletage = self
                sheet.show()
                
            } else {
                if customerNumPicker == nil {
                    customerNumPicker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
                    customerNumPicker?.delegate = self
                    customerNumPicker?.dataSource = self
                    customerNumPicker?.selectRow(maxNumOfCustom, inComponent: 0, animated: true)
                }
                let sheet = CustomActionSheet(customView: customerNumPicker!)
                sheet.deletage  = self
                sheet.show()
            }
                
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
        if pickerView == deskIdPicker {
            return numOfDesk * 50
        } else {
            return maxNumOfCustom * 50
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == deskIdPicker {
            return "\(row % numOfDesk + 1)号桌"
            
        } else {
            return "\(row % maxNumOfCustom + 1)人"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == deskIdPicker {
            self.selectDeskid = row % numOfDesk + 1
            
            pickerView.selectRow(numOfDesk * 24 + (row % numOfDesk), inComponent: 0, animated: false)
            
        } else {
            self.selectCustomerNum = row % maxNumOfCustom + 1
            pickerView.selectRow(maxNumOfCustom * 24 + (row % maxNumOfCustom), inComponent: 0, animated: false)
        }
        
        
    }
    
    // actionsheet deletage
    func didPressDoneButton(picker: UIView) {
        if picker == deskIdPicker {
            deskId = selectDeskid
            deskInfoView.reloadData()
            
            if customerNum == 0 {
                okButton.setTitle("没人数", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.redColor()
            } else {
                okButton.setTitle("下单", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.orangeColor()
            }
            
        } else {
            customerNum = selectCustomerNum
            deskInfoView.reloadData()
            
            if deskId == 0 {
                okButton.setTitle("没桌号", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.redColor()
            } else {
                okButton.setTitle("下单", forState: UIControlState.Normal)
                okButton.backgroundColor = UIColor.orangeColor()
            }
        }
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
