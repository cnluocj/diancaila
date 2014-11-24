//
//  OrderViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014 diancaila. All rights reserved.
//

import UIKit
import AudioToolbox

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JSONParseProtocol {
    
    var tableView1: UITableView!
    var tableView2: UITableView!
    var countView: UIView!
    var badge: UIButton!
    var priceLabel: UILabel!
    var chooseOverButton: UIButton!
    var orderListView: UIView!
    var orderListTableView: UITableView!
    var hDivide: UIView!
    
    let takeOrderButtonWidth = UIUtil.screenWidth/3*2
    
    let menuCellHeight = CGFloat(50)
    let menuDetailCellHeight = CGFloat(90)
    
    let countViewHeight = CGFloat(60)
    
    var contentHeight : CGFloat!
    
    // 菜单类型
    var menuType: NSArray = NSArray()
    
    // 菜单详细列表
    var menuDetail: [[Menu]] = []
    
    // 定位菜单类型
    var menuTypeIndex = 0
    
    
    // 订单     key 为 "menuTypeIndex_menuIndex"  用于记录每样订单在表中的位置
    var orderList: [String:Order] = [:]
    // 订单总份数
    var orderCount = 0
    // 金额
    var orderPrice = 0.0
    
    // 订单列表打开与否
    var orderListIsOpen = false
    
    // json解析器
    let jsonController = JSONController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "点餐"

        self.view.backgroundColor = UIColor.whiteColor()
        
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        // 除了导航，底下内容的高度
        contentHeight = UIUtil.screenHeight - UIUtil.statusHeight - navHeight
        
        
        // 目录菜单
        tableView1 = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth/3, contentHeight - countViewHeight))
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.backgroundColor = UIUtil.gray
        setExtraCellLineHidden(tableView1)
        self.view.addSubview(tableView1)
        
        
        let jsonString = "{\"menutype\":[{\"d_type_id\":\"1\",\"d_type_name\":\"热菜\",\"d_type_time\":\"2014-11-18 10:27:55\"},{\"d_type_id\":\"2\",\"d_type_name\":\"凉菜\",\"d_type_time\":\"2014-11-18 10:28:00\"},{\"d_type_id\":\"3\",\"d_type_name\":\"特色菜\",\"d_type_time\":\"2014-11-18 10:28:05\"},{\"d_type_id\":\"4\",\"d_type_name\":\"店铺主推\",\"d_type_time\":\"2014-11-18 10:28:12\"}]}"
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        jsonController.menuTypeDelegate = self
        jsonController.parseMenuType(jsonResult)
        
        // 分割线
        let divide = UIView(frame: CGRectMake(UIUtil.screenWidth/3, 0, 1, contentHeight - countViewHeight))
        divide.backgroundColor = UIColor.grayColor()
        divide.alpha = 0.3
        self.view.addSubview(divide)
        
        // 详细菜单
        tableView2 = UITableView(frame: CGRectMake(UIUtil.screenWidth/3+1, 0, (UIUtil.screenWidth/3)*2, contentHeight - countViewHeight))
        tableView2.delegate = self
        tableView2.dataSource = self
        self.view.addSubview(tableView2)
        setExtraCellLineHidden(tableView2)
        
        
         // 订单列表
        orderListView = UIView(frame: CGRectMake(0, contentHeight - countViewHeight, UIUtil.screenWidth, UIUtil.screenHeight*2))
        orderListView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(orderListView)
        
        
        orderListTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, contentHeight - countViewHeight))
        setExtraCellLineHidden(orderListTableView)
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        orderListTableView.backgroundColor = UIUtil.yellow_light
        orderListView.addSubview(orderListTableView)
        
        
        // 下单栏
        countView = UIView(frame: CGRectMake(0, contentHeight - countViewHeight, UIUtil.screenWidth, countViewHeight))
        countView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(countView)
        
        // 购物车
        let shoppingCartImg = UIImageView(frame: CGRectMake(20, 15, 30, 30))
        shoppingCartImg.image = UIImage(named: "shopping_cart")
        shoppingCartImg.userInteractionEnabled = true
        let click = UITapGestureRecognizer(target: self, action: "didPressOrderListView:")
        shoppingCartImg.addGestureRecognizer(click)
        countView.addSubview(shoppingCartImg)
        
        // 购物车badge
        badge = UIButton(frame: CGRectMake(40, 8, 25, 25))
        badge.setBackgroundImage(UIImage(named: "badge"), forState: UIControlState.Normal)
        badge.userInteractionEnabled = true
        let click1 = UITapGestureRecognizer(target: self, action: "didPressOrderListView:")
        badge.addGestureRecognizer(click1)
        badge.hidden = true
        countView.addSubview(badge)
        
        // 金额
        priceLabel = UILabel(frame: CGRectMake(80, 15, 150, 30))
        priceLabel.font = UIFont.systemFontOfSize(30)
        priceLabel.textColor = UIColor.orangeColor()
        priceLabel.text = "￥\(orderCount)"
        priceLabel.userInteractionEnabled = true
        let click2 = UITapGestureRecognizer(target: self, action: "didPressOrderListView:")
        priceLabel.addGestureRecognizer(click2)
        countView.addSubview(priceLabel)
        
        // 选好了按钮
        chooseOverButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/3*2, 0, UIUtil.screenWidth/3, countViewHeight))
        let color = UIColor(red: 0.98431, green: 0.31764, blue: 0.03137, alpha: 0.9)
        let color_highligh = UIColor(red: 0.98431, green: 0.31764, blue: 0.03137, alpha: 1)
        let color_disable = UIColor(red: 0.98431, green: 0.31764, blue: 0.03137, alpha: 0.5)
        let img = UIUtil.imageFromColor(takeOrderButtonWidth, height: countViewHeight, color: color)
        let img_high = UIUtil.imageFromColor(takeOrderButtonWidth, height: countViewHeight, color: color_highligh)
        let img_disable = UIUtil.imageFromColor(takeOrderButtonWidth, height: countViewHeight, color: color_disable)
        chooseOverButton.setBackgroundImage(img, forState: UIControlState.Normal)
        chooseOverButton.setBackgroundImage(img_high, forState: UIControlState.Highlighted)
        chooseOverButton.setBackgroundImage(img_disable, forState: UIControlState.Disabled)
        chooseOverButton.setTitle("选好了", forState: UIControlState.Normal)
        chooseOverButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        chooseOverButton.tintColor = UIColor.whiteColor()
        chooseOverButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        chooseOverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        chooseOverButton.enabled = false
        chooseOverButton.addTarget(self, action: "didPressChooseOverButton:", forControlEvents: UIControlEvents.TouchUpInside)
        countView.addSubview(chooseOverButton)
        
        // 横分割线
        hDivide = UIView(frame: CGRectMake(0, contentHeight - countViewHeight, UIUtil.screenWidth, 1))
        hDivide.backgroundColor = UIColor.grayColor()
        hDivide.alpha = 0.3
        self.view.addSubview(hDivide)
    }
    
    func didPressChooseOverButton(sender: UIButton) {
        let orderConfirmViewController = OrderConfirmViewController()
        orderConfirmViewController.orderList = orderList.values.array
        self.navigationController?.pushViewController(orderConfirmViewController, animated: true)
    }
    
    // 点击底部订单时，把订单详情展示出来
    func didPressOrderListView(sender: UIImage) {
        if orderListIsOpen {
            closeOrderListView()
           
        } else {
            
            openOrderListView()
        }
    }
    
    func openOrderListView() {
        orderListTableView.reloadData()
            
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
            self.orderListView.transform = CGAffineTransformMakeTranslation(0, -(self.contentHeight - self.countViewHeight))
        }, completion: nil)
        
        orderListIsOpen = true
        
        
        playSound("lock", soundType: "caf")
    }
    
    func closeOrderListView() {
         tableView2.reloadData()
        
         UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.orderListView.transform = CGAffineTransformMakeTranslation(0, self.contentHeight - self.countViewHeight)
        }, completion: nil)
        
        orderListIsOpen = false
    
        playSound("lock", soundType: "caf")
    }
    
    func playSound(soundName: String, soundType: String) {

        let path = "/System/Library/Audio/UISounds/\(soundName).\(soundType)"
        var sound: SystemSoundID = SystemSoundID()
        var url = NSURL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(CFURLCopyAbsoluteURL(url), &sound)
        AudioServicesPlaySystemSound(sound)
    }
    
    
    // JSONParseProtocol 相关
    func didFinishParseMenuTypeAndReturn(menuTypeArray: NSArray) {
        
        menuType = menuTypeArray ?? NSArray()
        tableView1.reloadData()
        tableView1.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    
    // about tableview delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.tableView1 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView1 {
            return menuType.count
        } else if tableView == self.tableView2 {
            if menuDetail.count == 0 {
                return 0
            } else {
                return menuDetail[menuTypeIndex].count
            }
        } else {
            return orderList.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if orderListTableView != nil {
            if tableView == orderListTableView {
                return "点餐清单"
            }
        }
        return nil
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuDetailCellStyle = "menuDetailCell"
        let menuCellStyle = "menuCell"
        
        if tableView == self.tableView1 {
            
            var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(menuCellStyle)
            if cell == nil {
                cell = MenuTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: menuCellStyle)
            }
            (cell as MenuTableViewCell).setText(menuType[indexPath.row].name)
            
            
            return cell! as UITableViewCell
            
        } else if tableView == self .tableView2 {
            
            
            let menu = menuDetail[menuTypeIndex][indexPath.row]
            var cell = MenuDetailTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: menuDetailCellStyle, _menuStyleIndex: menuTypeIndex, _menuIndex: indexPath.row, _menu: menu, _viewContriller: self, _superTableView: tableView)
            
            let tempCell  = cell as MenuDetailTableViewCell
            
            tempCell.set(menu.name, price: menu.price)
            
            let order: Order? = orderList["\(menuTypeIndex)_\(indexPath.row)"]
            if let tempOrder = order {
                tempCell.badge.hidden = false
                tempCell.badge.setTitle("\(tempOrder.count)", forState: UIControlState.Normal)
                tempCell.steper.value = Double(tempOrder.count)
                tempCell.preNum = tempCell.steper.value
            } else {
                tempCell.badge.hidden = true
                tempCell.steper.value = 0.0
            }
            
            return tempCell
            
        } else {
            let order = orderList.values.array[indexPath.row]
            var cell = MenuDetailTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: menuDetailCellStyle, _menuStyleIndex: order.menuTypeIndex, _menuIndex: order.menuIndex, _menu: order.menu, _viewContriller: self, _superTableView: tableView)
            
            let tempCell  = cell as MenuDetailTableViewCell
            
            tempCell.set(order.menu.name, price: order.menu.price)
            tempCell.badge.hidden = false
            tempCell.badge.setTitle("\(order.count)", forState: UIControlState.Normal)
            tempCell.steper.value = Double(order.count)
            tempCell.preNum = tempCell.steper.value
            tempCell.backgroundColor = UIUtil.yellow_light
            return tempCell
        }

    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableView1 {
            menuTypeIndex = indexPath.row
            tableView2.reloadData()
            
        } else {
            
        }
        
    }
    
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.tableView1 {
            return menuCellHeight
        } else {
            return menuDetailCellHeight
        }
    }
  
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == self.tableView2 || tableView == self.orderListTableView {
            return false
        } else {
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 隐藏tableview多余分割线
    func setExtraCellLineHidden(tableView: UITableView) {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = view
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
