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
    
    var segmentedItems = ["等待上菜", "未结订单", "全部订单"]
    
    var refreshButton: UIButton!
    
    let waitIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    let waitIndicator2 = UIUtil.waitIndicator()
    
    var user: User!
    
    // 等待上菜界面相关 -----------------------------------
    var didNotFinishView: UIView!
    var didNotFinishOrderTableView: UITableView!
    var searchBar: UISearchBar!
    var searchController: UISearchDisplayController!
    var foodStateAlert: UIAlertView!
    var foodMoreStateAlert: UIAlertView!
    var opButton: UIButton!
    var tableViewCellEditingIndexPath: NSIndexPath! // 正在编辑的菜 index
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
    // 未结订单 的 数据源
    var notPayOrders = NSMutableArray()
    
    // 全部订单相关 -------------------------------------------
    var allOrderView: UIView!
    var allOrderTableView: UITableView!
    // 全部订单 数据源 (暂时显示今天已结账订单)
    var allOrder = NSMutableArray()
    
    
    
    let httpController = HttpController()
    let jsonController = JSONController()
    
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
        var radius = CGFloat(70)
        opButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2 - radius/2, UIUtil.screenHeight - UIUtil.contentOffset - 20, radius, radius))
        opButton.setTitle("刷新", forState: UIControlState.Normal)
        opButton.backgroundColor = UIColor.orangeColor()
        opButton.setTitle("松开～", forState: UIControlState.Highlighted)
        opButton.layer.cornerRadius = radius/2
        opButton.addTarget(self, action: "didPressOpButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // 等待上菜订单界面 ---------------------------------------------------------------------------
        didNotFinishView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didNotFinishOrderTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didNotFinishOrderTableView.delegate = self
        didNotFinishOrderTableView.dataSource = self
        didNotFinishView.addSubview(didNotFinishOrderTableView)
        
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
        
        didNotPayTableView = UITableView(frame: CGRectMake(0, UIUtil.contentOffset, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset))
        didNotPayTableView.delegate = self
        didNotPayTableView.dataSource = self
        didNotPayView.addSubview(didNotPayTableView)
        
        
        
        // 全部订单界面 -----------------------------------------------------------------------
        allOrderView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        allOrderView.backgroundColor = UIColor.whiteColor()
        
        
        // 条件选择按钮组
        let choseButtonGroupView = UIView(frame: CGRectMake(0, UIUtil.contentOffset, UIUtil.screenWidth, 40))
        let dateChoseButton = UIButton(frame: CGRectMake(0, 5, UIUtil.screenWidth/2, 30))
        dateChoseButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        dateChoseButton.setTitle("今天", forState: UIControlState.Normal)
        dateChoseButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        dateChoseButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        dateChoseButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        dateChoseButton.layer.borderWidth = 2
        dateChoseButton.layer.cornerRadius = 5
        
        let deskChoseButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2, 5, UIUtil.screenWidth/2, 30))
        deskChoseButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        deskChoseButton.setTitle("全部", forState: UIControlState.Normal)
        deskChoseButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        deskChoseButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        deskChoseButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        deskChoseButton.layer.borderWidth = 2
        deskChoseButton.layer.cornerRadius = 5
        
        choseButtonGroupView.addSubview(dateChoseButton)
        choseButtonGroupView.addSubview(deskChoseButton)
        allOrderView.addSubview(choseButtonGroupView)
        
        
        allOrderTableView = UITableView(frame: CGRectMake(0, UIUtil.contentOffset + 50, UIUtil.screenWidth, UIUtil.screenHeight))
        // 如果不加这一条，tableview会向上偏移，与手机顶部对齐
//        allOrderTableView.contentInset = UIEdgeInsets(top: UIUtil.contentOffset + 50, left: 0, bottom: 0, right: 0)
        allOrderTableView.delegate = self
        allOrderTableView.dataSource = self
        
        allOrderView.addSubview(allOrderTableView)
      
        
        // 先加载 第一个界面的数据
        loadWaitOrderData()
        
        
        opButton.removeFromSuperview()
        self.view.addSubview(opButton)
    }
    
    
    
    func segmentAction(sender: UISegmentedControl) {
        numOfDidSelected = 0
        
        switch sender.selectedSegmentIndex {
        case 0:
            loadWaitOrderData()
            self.view = didNotFinishView
            
            opButton.removeFromSuperview()
            self.view.addSubview(opButton)
            
        case 1:
            loadNotPayOrderData()
            opButton.setTitle("刷新", forState: UIControlState.Normal)
            self.view = didNotPayView
            
            opButton.removeFromSuperview()
            self.view.addSubview(opButton)
            
        case 2:
            loadAllOrder()
            opButton.setTitle("刷新", forState: UIControlState.Normal)
            self.view = allOrderView
            
            opButton.removeFromSuperview()
            self.view.addSubview(opButton)
            
        default:
            break
        }
        
    }
    
    
    
    func didPressOpButton(sender: UIButton) {
        if numOfDidSelected > 0 {
            
            // 先把服务器那边的状态改了，再改本地
            for key in selectedItem.keys {
                let orderItem = orderList.objectAtIndex(key) as Order
                httpController.overOrder(HttpController.apiOverOrder(id: orderItem.id, stat: 1))
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
            opButton.setTitle("刷新", forState: UIControlState.Normal)
            opButton.backgroundColor = UIColor.orangeColor()
            
            
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                loadWaitOrderData()
            case 1:
                loadNotPayOrderData()
            case 2:
                loadAllOrder()
            default:
                return
            }
        }
    }
    
    
    // 加载数据 ---------------------------------------------------------
    func loadWaitOrderData() {
        waitIndicator.startAnimating()
        
        // 取数据前，清空数据
        orderDic = [:] // 转成 dic， 按照菜id分类 方便排序
        orderList.removeAllObjects()  // 有序的 tempdata
        filterData = NSArray() // 过滤的数据
        didNotFinishOrderTableView.reloadData()
        numOfDidSelected = 0
        selectedItem.removeAll(keepCapacity: false)
        
        httpController.onSearchWaitMenu(HttpController.apiWaitMenu(user.shopId))

    }
    
    func loadNotPayOrderData() {
        waitIndicator.startAnimating()
        
        // 取数据前，清空数据
        notPayOrders.removeAllObjects()
        didNotPayTableView.reloadData()
        
        httpController.onSearchDidNotPayOrder(HttpController.apiNotPayOrder(user.shopId))
        
    }
    
    
    func loadAllOrder() {
        waitIndicator.startAnimating()
        
        httpController.onSearchDidPayOrder(HttpController.apiDidPayOrder(user.shopId))
    }
    
    
    // JSONParseDelegate
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
    }
    
    func didFinishParseDidNotPayOrder(notPayOrders: NSMutableArray) {
        self.notPayOrders = notPayOrders
        
        waitIndicator.stopAnimating()
        
        didNotPayTableView.reloadData()
    }
    
    func didFinishParseDidPayOrder(payOrders: NSMutableArray) {
        self.allOrder = payOrders
        
        waitIndicator.stopAnimating()
        
        allOrderTableView.reloadData()
    }
    
    // HttpProtocol
    func didReceiveWaitMenu(result: NSDictionary) {
        jsonController.parseWaitMenu(result)
    }
    
    func didReceiveDidNotPayOrder(result: NSDictionary) {
        jsonController.parseDidNotPayOrder(result)
    }
    
    func didReceiveDidPayOrder(result: NSDictionary) {
        jsonController.parseDidPayOrder(result)
    }
    
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // UITableView data source / UITableView Deletage
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
            cell?.detailTextLabel?.text = "\((allOrder[indexPath.row] as DOrder).orderTime)"
            
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
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == didNotFinishOrderTableView {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                
                tableViewCellEditingIndexPath = indexPath
                
                foodStateAlert = UIAlertView(title: "选择状态", message: "", delegate: self, cancelButtonTitle: "更多", otherButtonTitles: "上菜")

                foodStateAlert.show()
                
            }
        }
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
                opButton.backgroundColor = UIUtil.flatBlue()
                opButton.setTitle("上菜", forState: UIControlState.Normal)
            } else {
                opButton.backgroundColor = UIColor.orangeColor()
                opButton.setTitle("刷新", forState: UIControlState.Normal)
            }
            tableView.reloadData()
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    // UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView == foodStateAlert {
            
            switch buttonIndex {
            case 0:
                foodMoreStateAlert = UIAlertView(title: "更多", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "退菜")
                foodMoreStateAlert.show()
            case 1:
                httpController.overOrder(HttpController.apiOverOrder(id: orderList[tableViewCellEditingIndexPath.row].id, stat: 1))
                orderList.removeObjectAtIndex(tableViewCellEditingIndexPath.row)
                
                didNotFinishOrderTableView.deleteRowsAtIndexPaths([tableViewCellEditingIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
            default:
                return
            }
            
        } else if alertView == foodMoreStateAlert {
            
            switch buttonIndex {
            case 1:
                httpController.overOrder(HttpController.apiOverOrder(id: orderList[tableViewCellEditingIndexPath.row].id, stat: 2))
                orderList.removeObjectAtIndex(tableViewCellEditingIndexPath.row)
                
                didNotFinishOrderTableView.deleteRowsAtIndexPaths([tableViewCellEditingIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
            default:
                return
            }
        }
    }
    
    
 
    // searchbar 相关
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
