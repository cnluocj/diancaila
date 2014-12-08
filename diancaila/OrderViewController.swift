//
//  OrderViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014 diancaila. All rights reserved.
//

import UIKit
import AudioToolbox

@objc protocol OrderViewControllerDeletage {
    optional func didAddFood()
}

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JSONParseProtocol, HttpProtocol, OrderConfirmViewControllerDelegate, UISearchBarDelegate {

    var tableView1: UITableView!
    var tableView2: UITableView!
    var countView: UIView!
    var badge: UIButton!
    var priceLabel: UILabel!
    var chooseOverButton: UIButton!
    var orderListView: UIView!
    var orderListTableView: UITableView!
    var hDivide: UIView!
    var backAlert: UIAlertView?
    var searchBar: UISearchBar!
    
    var searchBarTableView: UITableView!
    
    var filterData: NSArray?
    
    var searchBarIsEmpty = true
    
    // 加载
    var loadingIndicator: UIActivityIndicatorView!
    
    let takeOrderButtonWidth = UIUtil.screenWidth/3*2
    
    let menuCellHeight = CGFloat(50)
    let menuDetailCellHeight = CGFloat(90)
    
    let countViewHeight = CGFloat(60)
    
    var contentHeight : CGFloat!
    
    // 菜单类型
    var menuTypeArray: NSArray = NSArray()
    
    // 菜单详细列表
    var menuDetail: [String:[Menu]] = [:]
    
    // 定位菜单类型 (使用 typeid标识)
    var menuTypeIndex = 0
    
    var httpController = HttpController()
    
    
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
    
    
    // 加菜------------------
    var orderId: String?
    var delegate: OrderViewControllerDeletage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if orderId == nil {
            self.title = "点餐"
        } else {
            self.title = "加菜"
        }

        self.view.backgroundColor = UIColor.whiteColor()
        
        // 返回按钮
//        self.navigationItem.leftBarButtonItem = backButton()
        
        
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        // 除了导航，底下内容的高度
        contentHeight = UIUtil.screenHeight - UIUtil.statusHeight - navHeight
        

        // 获取数据
        httpController.onSearchMenuType(HttpController.apiMenuType)
        httpController.deletage = self
        jsonController.parseDelegate = self
        
        // 目录菜单
        tableView1 = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth/7 * 2, contentHeight - countViewHeight))
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.backgroundColor = UIUtil.gray
        setExtraCellLineHidden(tableView1)
        self.view.addSubview(tableView1)
        
        
        // 分割线
        let divide = UIView(frame: CGRectMake(UIUtil.screenWidth/7*2, 0, 1, contentHeight - countViewHeight))
        divide.backgroundColor = UIColor.grayColor()
        divide.alpha = 0.3
        self.view.addSubview(divide)
        
        
        // 详细菜单
        tableView2 = UITableView(frame: CGRectMake(UIUtil.screenWidth/7*2+1, 44, (UIUtil.screenWidth/7)*5, contentHeight - countViewHeight - 44))
        tableView2.delegate = self
        tableView2.dataSource = self
        self.view.addSubview(tableView2)
        setExtraCellLineHidden(tableView2)
        
        searchBar = UISearchBar(frame: CGRectMake(UIUtil.screenWidth/7*2+1, 0, (UIUtil.screenWidth/7)*5, 44))
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        // 搜索列表
        searchBarTableView = UITableView(frame: CGRectMake(UIUtil.screenWidth/7*2+1, 44, (UIUtil.screenWidth/7)*5, contentHeight - countViewHeight - 44))
        searchBarTableView.delegate = self
        searchBarTableView.dataSource = self
   
        
         // 订单列表
        orderListView = UIView(frame: CGRectMake(0, contentHeight - countViewHeight , UIUtil.screenWidth, UIUtil.screenHeight*2))
        orderListView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(orderListView)
        
        
        orderListTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, contentHeight - countViewHeight))
        setExtraCellLineHidden(orderListTableView)
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        orderListTableView.backgroundColor = UIUtil.yellow_light
        orderListView.addSubview(orderListTableView)
        
        
        // 下单栏
        countView = UIView(frame: CGRectMake(0, contentHeight - countViewHeight , UIUtil.screenWidth, countViewHeight))
        countView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(countView)
        
        // 购物车
        let shoppingCartImg = UIImageView(frame: CGRectMake(20, 15, 30, 30))
        shoppingCartImg.image = UIImage(named: "shopping")
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
        if orderId == nil {
            chooseOverButton.setTitle("选好了", forState: UIControlState.Normal)
        } else {
            chooseOverButton.setTitle("加菜", forState: UIControlState.Normal)
        }
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
        
        

        // 加载状态
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        loadingIndicator.backgroundColor = UIColor.grayColor()
        loadingIndicator.alpha = 0.8
        loadingIndicator.frame.size = CGSize(width: 150, height: 150)
        loadingIndicator.layer.cornerRadius = 5
        // 居中显示
        loadingIndicator.layer.position = CGPoint(x: UIUtil.screenWidth/2, y: UIUtil.screenHeight/3)
        loadingIndicator.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        loadingIndicator.frame = CGRectMake(UIUtil.screenWidth, UIUtil.screenHeight, 30, 30)
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(loadingIndicator)
        self.view.userInteractionEnabled = false
        
    }
    
    
    func backButton() -> UIBarButtonItem {
        
        let img: UIImage! = UIImage(named: "back")
        let btn = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        btn.frame = CGRectMake(0, 0, 20, 20)
        btn.setBackgroundImage(img, forState: UIControlState.Normal)
        btn.addTarget(self, action: "didPressBackButton:", forControlEvents: UIControlEvents.TouchUpInside)
        let backButton = UIBarButtonItem(customView: btn)
        return backButton
    }
    
    func didPressBackButton(sender: UIButton) {
            self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func didPressChooseOverButton(sender: UIButton) {
        if orderId == nil {
            let orderConfirmViewController = OrderConfirmViewController()
            orderConfirmViewController.orderList = orderList.values.array
            orderConfirmViewController.delegate = self
            self.navigationController?.pushViewController(orderConfirmViewController, animated: true)
        } else {
            
            // 等待处理
            let waitIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            waitIndicator?.alpha = 0.8
            waitIndicator?.layer.cornerRadius = 5
            waitIndicator?.frame = CGRectMake(UIUtil.screenWidth/2 - 75, UIUtil.screenHeight/3 - 75, 150, 150)
            waitIndicator?.backgroundColor = UIColor.grayColor()
            waitIndicator?.startAnimating()
            self.view.addSubview(waitIndicator!)
            self.view.userInteractionEnabled = false
            
            // 生成json
            var jsonDic = NSMutableDictionary()
            jsonDic["order_id"] = orderId
            
            var dishList = NSMutableArray()
            
            for order in orderList.values.array {
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
            httpController.submitOrder(HttpController.apiAddFood(), json: jsonStr!)
            
        }
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
    
    
    
    // HttpProtocol
    func didReceiveMenuTypeResults(result: NSDictionary) {
        
        jsonController.parseMenuType(result)
    }
    
    
    func didReceiveMenuResults(result: NSDictionary) {
        jsonController.parseMenu(result)
    }
    
    // 加菜成功
    func didReceiveOrderId(result: NSDictionary) {
        
        delegate?.didAddFood!()
        
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    
    
    // JSONParseProtocol 相关
    func didFinishParseMenuTypeAndReturn(menuTypeArray: NSArray) {
        
        self.menuTypeArray = menuTypeArray ?? NSArray()
        tableView1.reloadData()
        tableView1.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
        
        // 分配空间 menuDetail
        for menuType in self.menuTypeArray {
            let type = menuType as MenuType
            menuDetail[type.id] = []
        }
        
        // 根据获取的type id 继续获取菜单
        for menuType in self.menuTypeArray {
            let type = menuType as MenuType
            httpController.onSearchMenu(HttpController.apiMenu, typeId: type.id)
            
        }
        if self.menuTypeArray.count > 0 {
            self.menuTypeIndex = NSString(string: self.menuTypeArray[0].id).integerValue
        }
        
        
        loadingIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    func didFinishParseMenuByTypeIdAndReturn(menuArray: NSArray) {
        var typeId = "1"
        // 获取该组的typeid
        if menuArray.count > 0 {
            let menu = menuArray.objectAtIndex(0) as Menu
            typeId = menu.typeId
        }
        
        var count = 0
        for menu in menuArray {
            (menu as Menu).index = count++ // 标示在tableview中的位置
            menuDetail[typeId]?.append(menu as Menu)
        }
        
        tableView2.reloadData()
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
            return self.menuTypeArray.count
            
        } else if tableView == self.tableView2 {
            
            if menuDetail.count == 0{
                return 0
            } else {
                
                if let menuArray = menuDetail["\(menuTypeIndex)"] {
                    return menuArray.count
                    
                } else {
                    return 0
                }
            }
            
        } else if tableView == searchBarTableView {
            // 谓词搜索
            if let menuArray = menuDetail["\(menuTypeIndex)"] {
                let predicate = NSPredicate(format: "name contains [cd] %@", searchBar.text)
                filterData =  NSArray(array: NSMutableArray(array: menuArray).filteredArrayUsingPredicate(predicate!))
                if let fData = filterData {
                    return fData.count
                } else {
                    return 0
                }
                
            } else {
                return 0
            }
            
       } else {
            // 订单列表
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
            (cell as MenuTableViewCell).setText(self.menuTypeArray[indexPath.row].name)
            
            
            return cell! as UITableViewCell
            
        } else if tableView == self .tableView2 {
            
            var menu = (menuDetail["\(menuTypeIndex)"] as Array!)[indexPath.row]
        
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
            
        } else if tableView == searchBarTableView {
            var menu = filterData?.objectAtIndex(indexPath.row) as Menu
            
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
            cell.textLabel?.text = menu.name
            return cell
        }else {
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
            let typeIdIntValue = NSString(string: "\(menuTypeArray[indexPath.row].id)").integerValue
            menuTypeIndex = typeIdIntValue
            tableView2.reloadData()
            
        } else if tableView == searchBarTableView {
            searchBar.text = ""
            
            var searchIndex = (filterData?.objectAtIndex(indexPath.row) as Menu).index
            tableView2.scrollToRowAtIndexPath(NSIndexPath(forRow: searchIndex, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            searchBarTableView.removeFromSuperview()
        }
        
    }
    
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableView1 || tableView == searchBarTableView {
            return menuCellHeight
        } else {
            return menuDetailCellHeight
        }
    }
  
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (tableView == self.tableView2 && searchBarIsEmpty) || tableView == self.orderListTableView {
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

    
    // OrderConfirmViewControllerDelegate
    func OrderDidFinish() {
        orderList = [:]
        orderPrice = 0
        orderCount = 0
        orderListIsOpen = false
        
        tableView2.reloadData()
        badge.setTitle("\(orderCount)", forState: UIControlState.Normal)
        badge.hidden = true
        priceLabel.text = "￥\(orderPrice)"
        chooseOverButton.enabled = false
    }
    
    // UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBarTableView.removeFromSuperview()
            searchBarIsEmpty = true
        } else {
            searchBarIsEmpty = false
            self.view.addSubview(searchBarTableView)
        }
        searchBarTableView.reloadData()
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
