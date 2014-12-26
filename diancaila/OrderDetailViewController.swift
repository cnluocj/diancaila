//
//  OrderDetailViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/4.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HttpProtocol, SettleViewControllerDeletage, OrderViewControllerDeletage, UIPickerViewDataSource, UIPickerViewDelegate, CustomActionSheetDelegate, UIAlertViewDelegate, UIActionSheetDelegate {
    
    var orderListTableView: UITableView!
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var priceLabel: UILabel!
    
    var vipPriceLabel:UILabel!
    
    var popover: UIImageView!
    
    var popoverButton: UIButton!
    
    var cancelOrderAlert: UIAlertView?
    
    var changeTableIdAlert: UIAlertView?
    
    var changeTableIdActionSheet: CustomActionSheet?
    
    var changeTableIdPicker: UIPickerView?
    
    var finishFoodAlert: UIAlertView?
    
    
    var changeFoodStateActionSheet: UIActionSheet?
    
    var cancelFoodAlert: UIAlertView?
    
    var selectedOrderItemIndex = 0
    
    var numOfCancelFood = 0
    
    var isPopoverOpen = false
    
    let httpController = HttpController()
    
    var changeTableId = 1
    
    
    // 由上一层传入
    var orderId: String!
    var deskId: Int!
    
    // 当前获取
    var truePrice: Double?
    
    // tableview 数据源
    var orderDetail = NSMutableDictionary()
    var orderListDic = NSMutableDictionary()
    var orderListArray = NSMutableArray()
    var expandArray = [Bool]()
    
    // 菜品操作 数据源
    var foodOperateTitles = ["退菜","上菜"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if deskId == 0 {
            self.title = "外带"
        } else {
            self.title = "\(deskId)号桌"
        }
        
        httpController.deletage = self
        
        
        if truePrice == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "更多", style: UIBarButtonItemStyle.Bordered, target: self, action: "moreButtonDidPressed:")
            
        }

        var tableViewHeight = UIUtil.screenHeight - UIUtil.contentOffset - 60
        if truePrice != nil {
            tableViewHeight - 60
        }
        orderListTableView  = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, tableViewHeight), style: UITableViewStyle.Grouped)
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        self.view.addSubview(orderListTableView)
        
        
        // 结账栏 ---------------
        let settleView = UIView(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 60 , UIUtil.screenWidth, 60))
        settleView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(settleView)
        
        // 结账按钮 / 显示结账后金额
        let settleButton = UIButton(frame: CGRectMake(220, 0, UIUtil.screenWidth - 220, 60))
        let color = UIColor(red: 0.98431, green: 0.31764, blue: 0.03137, alpha: 0.9)
        settleButton.backgroundColor = color
        settleView.addSubview(settleButton)
        
        // 判断已结账还是未结账
        if (truePrice != nil) {
            settleButton.setTitle("\(truePrice!)", forState: UIControlState.Normal)
            
            // 订单号
            let priceLabel = UILabel(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 120, UIUtil.screenWidth, 60))
            priceLabel.backgroundColor = UIColor.whiteColor()
            priceLabel.textAlignment = NSTextAlignment.Center
            priceLabel.text = "订单号: \(orderId)"
            self.view.addSubview(priceLabel)
            
            // 横分割线
            let hDivide1 = UIView(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 120, UIUtil.screenWidth, 1))
            hDivide1.backgroundColor = UIColor.grayColor()
            hDivide1.alpha = 0.3
            self.view.addSubview(hDivide1)
            
        } else {
            
            settleButton.setTitle("结账", forState: UIControlState.Normal)
            settleButton.addTarget(self, action: "didPressSettleButton:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        // 原价
        priceLabel = UILabel(frame: CGRectMake(0, 0, 100, 60))
        priceLabel.textAlignment = NSTextAlignment.Center
        priceLabel.text = "原: 0"
        settleView.addSubview(priceLabel)
        // 会员价
        vipPriceLabel = UILabel(frame: CGRectMake(100, 0, 100, 60))
        vipPriceLabel.textAlignment = NSTextAlignment.Center
        vipPriceLabel.text = "VIP: 0"
        settleView.addSubview(vipPriceLabel)

        
        // 横分割线
        let hDivide = UIView(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 60, UIUtil.screenWidth, 1))
        hDivide.backgroundColor = UIColor.grayColor()
        hDivide.alpha = 0.3
        self.view.addSubview(hDivide)
        
        // popover
        
        popoverButton = UIButton(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset))
        popoverButton.addTarget(self, action: "moreButtonDidPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        popoverButton.alpha = 0
        popoverButton.userInteractionEnabled = false
        self.view.addSubview(popoverButton)
        
        popover = UIImageView(image: UIImage(named: "popover"))
        popover.frame = CGRectMake(UIUtil.screenWidth - 8 - 138, 5, 138, 144)
        popover.alpha = 0
        popover.userInteractionEnabled = false
        self.view.addSubview(popover)
        
        let addFoodButton = UIButton(frame: CGRectMake(0, 9, 138, 45))
        addFoodButton.addTarget(self, action: "didPressAddFoodButton:", forControlEvents: UIControlEvents.TouchUpInside)
        addFoodButton.setTitle("加菜", forState: UIControlState.Normal)
        addFoodButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addFoodButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        let changeTableButton = UIButton(frame: CGRectMake(0, 54, 138, 45))
        changeTableButton.addTarget(self, action: "changeButtonDidPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        changeTableButton.setTitle("换桌", forState: UIControlState.Normal)
        changeTableButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        changeTableButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        let cancelOrderButton = UIButton(frame: CGRectMake(0, 99, 138, 45))
        cancelOrderButton.addTarget(self, action: "cancelOrderButtonDidPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelOrderButton.setTitle("撤单", forState: UIControlState.Normal)
        cancelOrderButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelOrderButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        popover.addSubview(addFoodButton)
        popover.addSubview(changeTableButton)
        popover.addSubview(cancelOrderButton)
        
        
        
        loadData()
       
    }
    
    func cancelOrderButtonDidPressed(sender: UIButton) {
        hidePopover()
        
        cancelOrderAlert = UIAlertView(title: "确定删除此订单", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
        cancelOrderAlert!.show()
    }
    
    func changeButtonDidPressed(sender: UIButton) {
        hidePopover()
        
        changeTableIdPicker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
        changeTableIdPicker!.delegate = self
        changeTableIdPicker!.dataSource = self
        
        changeTableIdActionSheet =  CustomActionSheet(customView: changeTableIdPicker!)
        changeTableIdActionSheet!.deletage = self
        changeTableIdActionSheet!.show()
    }
    
    func moreButtonDidPressed(sender: UIView) {
        if isPopoverOpen {
            hidePopover()
        } else {
            showPopover()
        }
    }
    
    func hidePopover() {
        popover.userInteractionEnabled = false
        popover.alpha = 0
        isPopoverOpen = false
        
        popoverButton.userInteractionEnabled = false
    }
    
    func showPopover() {
        popover.userInteractionEnabled = true
        popover.alpha = 1
        isPopoverOpen = true
        
        popoverButton.userInteractionEnabled = true
        popoverButton.alpha = 0.5 
    }
    
    func didPressAddFoodButton(sender: UIButton) {
        hidePopover()
        
        let orderViewCV = OrderViewController()
        orderViewCV.delegate = self
        orderViewCV.orderId = orderId
        self.navigationController?.pushViewController(orderViewCV, animated: true)
    }
    
    func didPressSettleButton(sender: UIButton) {
        
        let settleVC = SettleViewController()
        settleVC.orderId = orderId
        settleVC.vipPrice = (orderDetail["vip_totalprice"] as NSString).doubleValue
        settleVC.deletage = self
//        self.navigationController?.presentViewController(settleVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(settleVC, animated: true)
    }
    
    
    func loadData() {
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.bringSubviewToFront(waitIndicator)
        self.view.userInteractionEnabled = false
        
        // 获取前 清空
        orderDetail.removeAllObjects()
        orderListArray.removeAllObjects()
        orderListDic.removeAllObjects()
        expandArray.removeAll(keepCapacity: false)
        
        httpController.onSearchOrderDetailById(orderId, url: HttpController.apiOrderDetail())
    }
    
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView == changeTableIdAlert {
            if buttonIndex == 1 {
                httpController.changeTableId(HttpController.apiChangeTableId(orderId, tableId: changeTableId))
                
                
                self.view.addSubview(waitIndicator)
                self.view.userInteractionEnabled = false
                waitIndicator.startAnimating()
            }    
        } else if alertView == cancelOrderAlert {
            if buttonIndex == 1 {
                httpController.cancelOrder(HttpController.apiCancelOrder(orderId))
                
                self.view.addSubview(waitIndicator)
                self.view.userInteractionEnabled = false
                waitIndicator.startAnimating()
            }
        } else if alertView == cancelFoodAlert {
            if buttonIndex == 1 {
                httpController.changeFoodState(HttpController.apiChangeFoodState(id: selectedFoodId, stat: 2))
                
                self.view.addSubview(waitIndicator)
                self.view.userInteractionEnabled = false
                waitIndicator.startAnimating()
                
            }
        } else if alertView == finishFoodAlert {
            if buttonIndex == 1 {
                
                httpController.changeFoodState(HttpController.apiChangeFoodState(id: selectedFoodId,stat: 1))
                
                self.view.addSubview(waitIndicator)
                self.view.userInteractionEnabled = false
                waitIndicator.startAnimating()
            }
        }
        
    }
    
    // MARK: CustomActionSheetDelegate
    func didPressDoneButton(actionSheet: UIView) {
        if actionSheet == changeTableIdActionSheet {
            
            var tit = ""
            if changeTableId == 0 {
                tit = "确定改为 外带"
            } else {
                tit = "确定把桌号改为 \(changeTableId)"
            }
            changeTableIdAlert = UIAlertView(title: tit, message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
            changeTableIdAlert!.show()
            
        }
    
    }
    
    // MARK: UIPickerViewDataSource, UIPickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == changeTableIdPicker {
            return 20
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == changeTableIdPicker {
            if row == 0 {
                return "外带"
            }
            return "第\(row)桌"
        } else {
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == changeTableIdPicker {
            changeTableId = row
        }
    }
    
    
    // MARK: - UITableViewDelegate  UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if orderDetail.count == 0 {
            return 0
        } else {
//            let list = orderDetail["list"] as NSArray
//            return list.count
            return orderListArray.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if orderDetail.count == 0 {
//            return 0
//        } else {
//            let list = orderDetail["list"] as NSArray
//            return list.count
//        }
        
        if expandArray[section] {
            return (orderListArray.objectAtIndex(section) as NSArray).count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderDetailCell = "orderDetailCell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: orderDetailCell)
        
        //* json 模版 ------------------------------------------------------------------------------------------------
        //{"order_id":"1-1-20141203165755-6910","list":[{"dish_id":"9","dish_name":"肉龙","num":"1","totalprice":"28"},{"dish_id":"10","dish_name":"三不馆er招牌香香骨（小）","num":"1","totalprice":"68"},{"dish_id":"11","dish_name":"三不馆er招牌香香骨（中）","num":"1","totalprice":"102"}]}
        
        
        let sameDishArray = orderListArray.objectAtIndex(indexPath.section) as NSArray
        
        let item = sameDishArray[indexPath.row] as NSDictionary
        cell.textLabel?.text = item["dish_name"] as? String
        let price = item["price"] as String
        let vipPrice = item["vip_price"] as String
        let specialPrice = item["special_price"] as String
        let state = item["state"] as String
 
        let separator = UIView(frame: CGRectMake(16, 21.5, 359, 1))
        separator.backgroundColor = UIColor.grayColor()
        
        if sameDishArray.count == 1 {
            cell.detailTextLabel?.text = "¥\(vipPrice) / ¥\(price)"
            
            if state == "1" {
                cell.textLabel?.textColor = UIColor.grayColor()
                cell.addSubview(separator)
            }
            
        } else  {
            
            if expandArray[indexPath.section] {
                cell.detailTextLabel?.text = "¥\(vipPrice) / ¥\(price)"
                
                if state == "1" {
                    cell.textLabel?.textColor = UIColor.grayColor()
                    cell.addSubview(separator)
                }
            } else {
                
                cell.detailTextLabel?.text = "x \(sameDishArray.count)   ¥\(vipPrice) / ¥\(price)"
                
                var isAllDidFinish = true
                for food in sameDishArray {
                    let tempFood = food as NSDictionary
                    if tempFood.objectForKey("state") as String == "0" {
                        isAllDidFinish = false
                        break
                    }
                }
                if isAllDidFinish {
                    cell.textLabel?.textColor = UIColor.grayColor()
                    cell.addSubview(separator)
                }
                
            }
        }
       
        return cell
    }
    
    
    var selectedFoodId = ""
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let array = orderListArray.objectAtIndex(indexPath.section) as NSArray
        if array.count > 1 {
            if !expandArray[indexPath.section] {
                
                expandArray[indexPath.section] = true
                
                var indexPaths = [NSIndexPath]()
                for row in 1..<array.count {
                    indexPaths.append(NSIndexPath(forRow: row, inSection: indexPath.section))
                }
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Top)
                
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                
                return
            }
        }
        
        if truePrice == nil {
            selectedFoodId = (array.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("id") as String
            let state = (array.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("state") as String
            if state == "1" {
                changeFoodStateActionSheet = UIActionSheet(title: "选择操作", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: foodOperateTitles[0])
                
            } else {
                changeFoodStateActionSheet = UIActionSheet(title: "选择操作", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: foodOperateTitles[0], otherButtonTitles: foodOperateTitles[1])
            }
            changeFoodStateActionSheet!.showInView(self.view)
                
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet == changeFoodStateActionSheet {
            if buttonIndex == 0 {
                
                cancelFoodAlert = UIAlertView(title: "确定要退菜", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                cancelFoodAlert?.show()
                
            } else if buttonIndex == 2 {
                
                finishFoodAlert = UIAlertView(title: "确定要上菜", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                finishFoodAlert?.show()
            }
        }
    }
    
    
    // MARK: HttpProtocol
    func didReceiveOrderDetail(result: NSMutableDictionary) {
        orderDetail = result
        
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
//        println("detail \(orderDetail)")
        let totalPrice = orderDetail["totalprice"] as String
        let vipPrice = orderDetail["vip_totalprice"] as String
        priceLabel.text =   "原: \(totalPrice)"
        vipPriceLabel.text = "VIP: \(vipPrice)"
        
        
        // 把相同 dish ID 的项目放到一起
        let list = orderDetail["list"] as NSArray
        for item in list {
            let temp  = item as NSDictionary
            let id = temp["dish_id"] as String
            if orderListDic[id] == nil {
                orderListDic[id] = NSMutableArray()
            }
            orderListDic[id]?.addObject(temp)
        }
        
        // 再 化为array
        for key in orderListDic.allKeys {
            let k = key as String
            orderListArray.addObject(orderListDic[k]!)
            
            expandArray.append(false)
        }
        
        
        orderListTableView.reloadData()
    }
    
    func didReceiveChangeTableIdState(result: NSMutableDictionary) {
        if result["error"] == nil {
            waitIndicator.stopAnimating()
            self.view.userInteractionEnabled = true
            waitIndicator.removeFromSuperview()
            
            if changeTableId == 0 {
                self.title = "外带"
            } else {
                self.title = "\(changeTableId)号桌"
            }
        }
    }
    
    func didReceiveCancelOrderState(result: NSMutableDictionary) {
        if result["error"] == nil {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didReceiveChangeFoodState(result: NSDictionary) {
        if result["error"] == nil {
            self.view.userInteractionEnabled = true
            waitIndicator.stopAnimating()
            waitIndicator.removeFromSuperview()
            
            loadData()
        }
    }

    // MARK: SettleViewControllerDeletage
    func didSettle() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: OrderViewControllerDeletage
    func didAddFood() {
       loadData()
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
