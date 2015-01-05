//
//  OrderListViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/26.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchDisplayDelegate, HttpProtocol, JSONParseProtocol, UIAlertViewDelegate {
    
    var segmentedControl: UISegmentedControl!
    
    var segmentedItems = ["等待上菜", "未结订单", "今天已结"]
    
    var refreshButton: UIButton!
    
    let waitIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    let waitIndicator2 = UIUtil.waitIndicator()
    
    var user: User!
    
    // 等待上菜界面相关 -----------------------------------
    var didNotFinishView: UIView!
    var didNotFinishOrderTableView: UITableView!
    var didNotFinishViewRefresh: UIRefreshControl!
    var searchBar: UISearchBar!
    var searchController: UISearchDisplayController!
//    var foodStateAlert: UIAlertView!
//    var foodMoreStateAlert: UIAlertView!
    var finishFoodAlert: UIAlertView?
    var cancelFoodAlert: UIAlertView?
    var opButton: UIButton!
    var opButtonIsShow = false
    var radius = CGFloat(70)
    var tableViewCellEditingIndexPath: NSIndexPath! // 正在编辑的菜 index
    
    var isBatchCancel = false  //批量上菜
    
    // 等待上菜 table 的 数据源
    var orderDic: [String:[Order]] = [:] // 转成 dic， 按照菜id分类 方便排序
//    var orderList = [Order]()  // 有序的 tempdata
    var orderList = NSMutableArray()
    var filterData: NSArray? // 过滤的数据
    var numOfDidSelected = 0 // 被选中的个数  todo 需废弃
    var selectedItem = [Int : Order]()
    
    // 未结订单相关 ------------------------------------------
    var didNotPayView: UIView!
    var didNotPayTableView: UITableView!
    var didNotPayRefresh: UIRefreshControl!
    // 未结订单 的 数据源
    var notPayOrders = NSMutableArray()
    
    // 全部订单相关 -------------------------------------------
    var allOrderView: UIView!
    var allOrderTableView: UITableView!
    var moneyLabel: UILabel!
    var allOrderRefresh: UIRefreshControl!
    // 全部订单 数据源 (暂时显示今天已结账订单)
    var allOrder = NSMutableArray()
    
    
    
    let httpController = HttpController()
    let jsonController = JSONController()
    
    // http id
    let httpIdWithChangeFoodState = "ChangeFoodState"
    let httpIdWithChangeFoodState2 = "ChangeFoodState2" // 应付批量操作
    let httpIdWithWaitMenu = "WaitMenu"
    let httpIdWithNotPayOrder = "NotPayOrder"
    let httpIdWithDidPayOrder = "DidPayOrder"
    let httpIdWithTodayCount = "TodayCount"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单"
            
        // 解决searchbar 抖动问题
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        httpController.deletage = self
        jsonController.parseDelegate = self
        
        
        waitIndicator.frame = CGRectMake(0, 0, 30, 30)
        let rightButtonItem = UIBarButtonItem(customView: waitIndicator)
        self.navigationItem.rightBarButtonItem = rightButtonItem

        
        segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setWidth(UIUtil.screenWidth/5, forSegmentAtIndex: 0)
        segmentedControl.setWidth(UIUtil.screenWidth/5, forSegmentAtIndex: 1)
        segmentedControl.setWidth(UIUtil.screenWidth/5, forSegmentAtIndex: 2)
        segmentedControl.addTarget(self, action: "segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = segmentedControl
        
        
        // deleteButton -- didNotFinishView
        opButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2 - radius/2, UIUtil.screenHeight, radius, radius))
        opButton.setTitle("上菜", forState: UIControlState.Normal)
        opButton.backgroundColor = UIColor.orangeColor()
        opButton.layer.cornerRadius = radius/2
        opButton.addTarget(self, action: "didPressOpButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // 等待上菜订单界面 ---------------------------------------------------------------------------
        didNotFinishView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didNotFinishOrderTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight), style: UITableViewStyle.Grouped)
        didNotFinishOrderTableView.delegate = self
        didNotFinishOrderTableView.dataSource = self
        didNotFinishView.addSubview(didNotFinishOrderTableView)
        
        // todo 下拉刷新
        didNotFinishViewRefresh = UIRefreshControl()
        didNotFinishViewRefresh.addTarget(self, action: "refreshDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        didNotFinishOrderTableView.addSubview(didNotFinishViewRefresh)
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
//        searchBar.backgroundImage = UIUtil.imageFromColor(self.view.frame.width, height: 44, color: UIUtil.gray_system)
        searchBar.placeholder = "搜索"
        didNotFinishOrderTableView.tableHeaderView = searchBar
        
        // 绑定 UISearchDisplayController
        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchController.delegate = self
        searchController.searchResultsDelegate = self
        searchController.searchResultsDataSource = self
        
        
        self.view = didNotFinishView
        
        
        // 未结订单界面 ----------------------------------------------------
        didNotPayView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didNotPayView.backgroundColor = UIColor.whiteColor()
        
        didNotPayTableView = UITableView(frame: CGRectMake(0, UIUtil.contentOffset, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        didNotPayTableView.delegate = self
        didNotPayTableView.dataSource = self
        didNotPayView.addSubview(didNotPayTableView)
        
        didNotPayRefresh = UIRefreshControl()
        didNotPayRefresh.addTarget(self, action: "refreshDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        didNotPayTableView.addSubview(didNotPayRefresh)
        
        
        
        // 全部订单界面 -----------------------------------------------------------------------
        allOrderView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        allOrderView.backgroundColor = UIUtil.gray_system
        
        
        // todo 条件选择按钮组

        
        moneyLabel = UILabel(frame: CGRectMake(0, UIUtil.contentOffset, UIUtil.screenWidth, 50))
        moneyLabel.backgroundColor = UIUtil.navColor
        moneyLabel.textColor = UIColor.whiteColor()
        moneyLabel.textAlignment = NSTextAlignment.Center
        allOrderView.addSubview(moneyLabel)
        
        
        allOrderTableView = UITableView(frame: CGRectMake(0, UIUtil.contentOffset + 50, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset - 50))
        // 如果不加这一条，tableview会向上偏移，与手机顶部对齐
//        allOrderTableView.contentInset = UIEdgeInsets(top: UIUtil.contentOffset + 50, left: 0, bottom: 0, right: 0)
        allOrderTableView.delegate = self
        allOrderTableView.dataSource = self
        allOrderView.addSubview(allOrderTableView)
        
        allOrderRefresh = UIRefreshControl()
        allOrderRefresh.addTarget(self, action: "refreshDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        allOrderTableView.addSubview(allOrderRefresh)
      
        
        // 先加载 第一个界面的数据
        didNotFinishViewRefresh.beginRefreshing()
        didNotFinishViewRefresh.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        didNotFinishOrderTableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.height)
        
        
    }
    
    
    
    func segmentAction(sender: UISegmentedControl) {
        numOfDidSelected = 0
        
        switch sender.selectedSegmentIndex {
        case 0:
            loadWaitOrderData()
            self.view = didNotFinishView
            
        case 1:
            loadNotPayOrderData()
            self.view = didNotPayView
            
            opButton.removeFromSuperview()
            
        case 2:
            loadAllOrder()
            self.view = allOrderView
            
            opButton.removeFromSuperview()
            
        default:
            break
        }
        
    }
    
    
    func refreshDidChange(sender: UIRefreshControl) {
        if sender == didNotFinishViewRefresh {
           loadWaitOrderData()
        } else if sender == didNotPayRefresh {
            loadNotPayOrderData()
        } else if  sender == allOrderRefresh {
            loadAllOrder()
        }
    }
    
    func didPressOpButton(sender: UIButton) {
        
        if numOfDidSelected > 0 {
            isBatchCancel = true
            
            // 先把服务器那边的状态改了，再改本地
            for key in selectedItem.keys {
                let orderItem = orderList.objectAtIndex(key) as Order
                httpController.getWithUrl(HttpController.apiChangeFoodState2(id: orderItem.id, stat: 1), forIndentifier: httpIdWithChangeFoodState2)
            }
            
            // todo 服务器传回数据后，再对表进行修改
            let array = NSMutableArray()
            let set = NSMutableIndexSet()
            for a in selectedItem.keys.array {
                array.addObject(NSIndexPath(forRow: a, inSection: 0))
                set.addIndex(a)
            }
            orderList.removeObjectsAtIndexes(set)
            didNotFinishOrderTableView.deleteRowsAtIndexPaths(NSArray(array: array), withRowAnimation: UITableViewRowAnimation.Top)
            
            
            // 清空选中的数据源
            selectedItem.removeAll(keepCapacity: false)
            numOfDidSelected = 0
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.opButton.frame.origin = CGPoint(x: UIUtil.screenWidth/2 - self.radius/2, y: UIUtil.screenHeight)
                
                }, completion: { (finished: Bool) -> Void in
                    self.opButton.removeFromSuperview()
            })

            
            
        }

    }
    
    
    // 加载数据 ---------------------------------------------------------
    func loadWaitOrderData() {
        waitIndicator.startAnimating()
        
        // 取数据前，清空数据
        orderDic = [:] // 转成 dic， 按照菜id分类 方便排序
        orderList.removeAllObjects()  // 有序的 tempdata
        filterData = NSArray() // 过滤的数据
        numOfDidSelected = 0
        selectedItem.removeAll(keepCapacity: false)
        
        httpController.getWithUrl(HttpController.apiWaitMenu(user.shopId), forIndentifier: httpIdWithWaitMenu)

    }
    
    func loadNotPayOrderData() {
        waitIndicator.startAnimating()
        
        // 取数据前，清空数据
        notPayOrders.removeAllObjects()
        
        httpController.getWithUrl(HttpController.apiNotPayOrder(user.shopId), forIndentifier: httpIdWithNotPayOrder)
        
    }
    
    
    func loadAllOrder() {
        waitIndicator.startAnimating()
        
        httpController.getWithUrl(HttpController.apiDidPayOrder(user.shopId), forIndentifier: httpIdWithDidPayOrder)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let shopId = defaults.objectForKey("shopId") as String
        httpController.getWithUrl(HttpController.apiTodayCount(shopId), forIndentifier: httpIdWithTodayCount)
    }
    
    
    // MARK: - JSONParseDelegate
    func didFinishParseWaitMenu(menuArray: NSMutableArray) {
        let tempData = menuArray
        
        for ord in tempData {
            let order = ord as Order
            if self.orderDic[order.menu.id] == nil {
                self.orderDic[order.menu.id] = [Order]()
            }
            self.orderDic[order.menu.id]?.append(order)
        }
        
        var count = 0
        for ordlist in self.orderDic.values {
            for ord in ordlist {
                ord.menuIndex = count++ // 定位标记
                self.orderList.addObject(ord)
            }
        }
        
        waitIndicator.stopAnimating()
        
        didNotFinishOrderTableView.reloadData()
        
        didNotFinishViewRefresh.endRefreshing()
    }
    
    func didFinishParseDidNotPayOrder(notPayOrders: NSMutableArray) {
        self.notPayOrders = notPayOrders
        
        waitIndicator.stopAnimating()
        
        didNotPayTableView.reloadData()
        
        didNotPayRefresh.endRefreshing()
    }
    
    func didFinishParseDidPayOrder(payOrders: NSMutableArray) {
        self.allOrder = payOrders
        
        waitIndicator.stopAnimating()
        
        allOrderTableView.reloadData()
        
        allOrderRefresh.endRefreshing()
    }
    
    // MARK: - HttpProtocol
    func httpControllerDidReceiveResult(result: NSDictionary, forIdentifier identifier: String) {
        switch identifier {
        case httpIdWithWaitMenu:
            jsonController.parseWaitMenu(result)
            
            
        case httpIdWithNotPayOrder:
            jsonController.parseDidNotPayOrder(result)
            
        case httpIdWithDidPayOrder:
            jsonController.parseDidPayOrder(result)
            
        case httpIdWithChangeFoodState:
            waitIndicator2.removeFromSuperview()
            self.view.userInteractionEnabled = true
            
            orderList.removeObjectAtIndex(tableViewCellEditingIndexPath.row)
            
            didNotFinishOrderTableView.deleteRowsAtIndexPaths([tableViewCellEditingIndexPath], withRowAnimation: UITableViewRowAnimation.Top)

        case httpIdWithChangeFoodState2:
            waitIndicator2.removeFromSuperview()
            // todo 处理批量上菜 返回消息
            
        case httpIdWithTodayCount:
            if result["error"] == nil {
                let data = result["result"] as NSDictionary
                let money: AnyObject? = data["earncount"]
                moneyLabel.text = "今天营业额为: ¥ \(money!)"
            } else {
                moneyLabel.text = "null"
            }
            
        default:
            return
        }
    }

    
    // MARK: - UITableView data source / UITableView Deletage
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == didNotFinishOrderTableView {
            return orderList.count
            
        } else if tableView == didNotPayTableView {
            return notPayOrders.count
        } else if tableView == allOrderTableView{
            return allOrder.count
        } else {
            
            // 谓词搜索
            let predicate = NSPredicate(format: "menu.name contains [cd] %@", searchController.searchBar.text)
            filterData =  NSArray(array: NSMutableArray(array: orderList).filteredArrayUsingPredicate(predicate!))
            if let fdata = filterData {
                return fdata.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "mcell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        
        
        if tableView == didNotFinishOrderTableView {
            let orderItem = orderList.objectAtIndex(indexPath.row) as Order
            
            cell?.textLabel?.text = orderItem.menu.name
            if orderItem.deskId == 0 {
                cell?.detailTextLabel?.text = "外带"
            } else {
                cell?.detailTextLabel?.text = "\(orderItem.deskId)号桌"
            }
            cell?.detailTextLabel?.textColor = UIColor.redColor()
            
            // 点击时不高亮
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            
            if orderItem.isSelected {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            
        } else if tableView == didNotPayTableView {
            if (notPayOrders[indexPath.row] as DOrder).deskId == 0 {
                cell?.textLabel?.text = "外带"
                
            } else {
                cell?.textLabel?.text = "\((notPayOrders[indexPath.row] as DOrder).deskId)号桌"
            }
            cell?.detailTextLabel?.text = "\((notPayOrders[indexPath.row] as DOrder).orderTime)"
            
        } else if tableView == allOrderTableView {
            if (allOrder[indexPath.row] as DOrder).deskId == 0 {
                cell?.textLabel?.text = "外带"
                
            } else {
                cell?.textLabel?.text = "\((allOrder[indexPath.row] as DOrder).deskId)号桌"
                
            }
            let date = (allOrder[indexPath.row] as DOrder).orderTime
            let time = date.componentsSeparatedByString(" ")[1]
            let earn = (allOrder[indexPath.row] as DOrder).truePrice
            cell?.detailTextLabel?.text = "¥ \(earn)  |  \(time)"
            
        } else {
            let order: Order = filterData?.objectAtIndex(indexPath.row) as Order
            cell?.textLabel?.text = order.menu.name
            if order.deskId == 0 {
                cell?.detailTextLabel?.text = "外带"
            } else {
                cell?.detailTextLabel?.text = "\(order.deskId)号桌"
            }
        }
        
        
        return cell!
    }
    
    
    // 必须重写这个方法，不然table无法左滑显示操作选项
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let finishAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "上菜") { (UITableViewRowAction, NSIndexPath) -> Void in
            
            self.tableViewCellEditingIndexPath = indexPath
            
            self.finishFoodAlert = UIAlertView(title: "确定上菜", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            
            self.finishFoodAlert?.show()
        }
        
        let cancelAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "退菜") { (UITableViewRowAction, NSIndexPath) -> Void in
            
            self.tableViewCellEditingIndexPath = indexPath
            
            self.cancelFoodAlert = UIAlertView(title: "确定退菜", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            self.cancelFoodAlert?.show()
        }
        
        finishAction.backgroundColor = UIColor(red: 237.0/255.0, green: 75.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        cancelAction.backgroundColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        
        return [finishAction, cancelAction]
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == didNotFinishOrderTableView {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "编辑状态"
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if tableView == searchController.searchResultsTableView {
            searchController.setActive(false, animated: true)
            
            let order: Order = filterData?.objectAtIndex(indexPath.row) as Order
            let outSideIndexPath = NSIndexPath(forRow: order.menuIndex, inSection: order.menuTypeIndex)
            didNotFinishOrderTableView.scrollToRowAtIndexPath(outSideIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            
        } else if tableView == didNotPayTableView {
            
            let controller = OrderDetailViewController()
            let orderDesc = notPayOrders[indexPath.row] as DOrder
            controller.orderId = orderDesc.id
            controller.deskId = orderDesc.deskId
            self.hidesBottomBarWhenPushed  = true // 隐藏tabbar
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if tableView == allOrderTableView{
            
            let controller = OrderDetailViewController()
            let orderDesc = allOrder[indexPath.row] as DOrder
            controller.orderId = orderDesc.id
            controller.deskId = orderDesc.deskId
            controller.truePrice = orderDesc.truePrice
            self.hidesBottomBarWhenPushed  = true // 隐藏tabbar
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if tableView == didNotFinishOrderTableView {
            let orderItem = orderList.objectAtIndex(indexPath.row) as Order
            
//            orderList[indexPath.row].isSelected = !orderList[indexPath.row].isSelected
            orderItem.isSelected = !orderItem.isSelected
            if (orderItem.isSelected) {
                numOfDidSelected++
                selectedItem[indexPath.row] = orderItem
            } else {
                numOfDidSelected--
                selectedItem.removeValueForKey(indexPath.row)
            }
            
            if numOfDidSelected > 0 {
                self.view.addSubview(opButton)
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                        self.opButton.frame.origin = CGPoint(x: UIUtil.screenWidth/2 - self.radius/2, y: UIUtil.screenHeight - self.radius - 16)
                    }, completion: { (finished: Bool) -> Void in
                        
                })
                
            } else {
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.opButton.frame.origin = CGPoint(x: UIUtil.screenWidth/2 - self.radius/2, y: UIUtil.screenHeight)
                    
                    }, completion: { (finished: Bool) -> Void in
                        self.opButton.removeFromSuperview()
                })
                
            }
            tableView.reloadData()
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView == finishFoodAlert {
            
            switch buttonIndex {
            case 1:
                self.waitIndicator2.startAnimating()
                self.view.addSubview(self.waitIndicator2)
                self.view.userInteractionEnabled = false
                
                httpController.getWithUrl(HttpController.apiChangeFoodState(id: orderList[tableViewCellEditingIndexPath.row].id, stat: 1), forIndentifier: httpIdWithChangeFoodState)
            default:
                return
            }
            
        } else if alertView == cancelFoodAlert {
            
            switch buttonIndex {
            case 1:
                self.waitIndicator2.startAnimating()
                self.view.addSubview(self.waitIndicator2)
                self.view.userInteractionEnabled = false
                
                httpController.getWithUrl(HttpController.apiChangeFoodState(id: orderList[tableViewCellEditingIndexPath.row].id, stat: 2), forIndentifier: httpIdWithChangeFoodState)
            default:
                return
            }
        }
    }
    
    
 
    // MARK: - UISearchBarDelegate
    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
    }
    
    func searchDisplayControllerWillEndSearch(controller: UISearchDisplayController) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        loadNotPayOrderData()
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillDisappear(animated: Bool) {
//        refreshButton.removeFromSuperview()
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
