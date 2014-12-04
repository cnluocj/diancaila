//
//  OrderListViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/26.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchDisplayDelegate, HttpProtocol, JSONParseProtocol, UIAlertViewDelegate {
    
    var didNotFinishView: UIView!
    var allOrderView: UIView!
    var didNotPayView: UIView!
    var didNotPayTableView: UITableView!
    
    var didNotFinishOrderTableView: UITableView!
    var segmentedControl: UISegmentedControl!
    
    var searchBar: UISearchBar!
    var searchController: UISearchDisplayController!
    
    var allOrderTableView: UITableView!
    
    var foodStateAlert: UIAlertView!
    
    var segmentedItems = ["等待上菜", "未结订单", "全部订单"]
    
    // 数据源
    // 等待上菜 的 数据源
    var tempData = NSMutableArray()
    var orderDic: [String:[Order]] = [:] // 转成 dic， 按照菜id分类 方便排序
    var orderList = [Order]()  // 有序的 tempdata
    var filterData: NSArray? // 过滤的数据
    
    // 未结订单 的 数据源
    var notPayOrders = NSMutableArray()
    
    
    var tableViewCellEditingIndexPath: NSIndexPath!
    
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
        
        loadWaitOrderData()

        
        segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setWidth(UIUtil.screenWidth/5, forSegmentAtIndex: 0)
        segmentedControl.setWidth(UIUtil.screenWidth/5, forSegmentAtIndex: 1)
        segmentedControl.setWidth(UIUtil.screenWidth/5, forSegmentAtIndex: 2)
        segmentedControl.addTarget(self, action: "segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = segmentedControl
        
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
        let dateChoseButton = UIButton(frame: CGRectMake(20, 5, 130, 30))
        dateChoseButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        dateChoseButton.setTitle("今天", forState: UIControlState.Normal)
        dateChoseButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        dateChoseButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        dateChoseButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        dateChoseButton.layer.borderWidth = 2
        dateChoseButton.layer.cornerRadius = 5
        
        let deskChoseButton = UIButton(frame: CGRectMake(170, 5, 130, 30))
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
      
    
       
    }
    
    // 加载数据
    func loadWaitOrderData() {
        httpController.onSearchWaitMenu(HttpController.apiWaitMenu)

    }
    
    func loadNotPayOrderData() {
        httpController.onSearchDidNotPayOrder(HttpController.apiNotPayOrder)
        
    }
    
    
    // JSONParseDelegate
    func didFinishParseWaitMenu(menuArray: NSMutableArray) {
        self.tempData = menuArray
        
        for ord in self.tempData {
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
                self.orderList.append(ord)
            }
        }
        didNotFinishOrderTableView.reloadData()
    }
    
    func didFinishParseDidNotPayOrder(notPayOrders: NSMutableArray) {
        self.notPayOrders = notPayOrders
        didNotPayTableView.reloadData()
    }
    
    // HttpProtocol
    func didReceiveWaitMenu(result: NSDictionary) {
        jsonController.parseWaitMenu(result)
    }
    
    func didReceiveDidNotPayOrder(result: NSDictionary) {
        jsonController.parseDidNotPayOrder(result)
    }
    
    
    func segmentAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view = didNotFinishView
        case 1:
            loadNotPayOrderData()
            self.view = didNotPayView
        case 2:
            self.view = allOrderView
        default:
            break
        }
        
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
            
            cell?.textLabel?.text = orderList[indexPath.row].menu.name
            cell?.detailTextLabel?.text = "\(orderList[indexPath.row].deskId)号桌"
            cell?.detailTextLabel?.textColor = UIColor.redColor()
            
            let view  =  UIView(frame: CGRectMake(0, 0, 100, cell!.frame.height))
            view.backgroundColor = UIColor.orangeColor()

            cell?.editingAccessoryView = view
            
        } else if tableView == didNotPayTableView {
            cell?.textLabel?.text = "\((notPayOrders[indexPath.row] as DOrder).deskId)号桌"
            cell?.detailTextLabel?.text = "\((notPayOrders[indexPath.row] as DOrder).orderTime)"
            
        } else {
            let order: Order = filterData?.objectAtIndex(indexPath.row) as Order
            cell?.textLabel?.text = order.menu.name
            cell?.detailTextLabel?.text = "\(order.deskId)号桌"
        }
        
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == didNotFinishOrderTableView {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                
                tableViewCellEditingIndexPath = indexPath
                
                foodStateAlert = UIAlertView(title: "选择状态", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "上菜", "退菜")

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
            controller.price = orderDesc.price
            controller.vipPrice = orderDesc.vipPrice
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    // UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView == foodStateAlert {
            
            switch buttonIndex {
            case 2:
                httpController.overOrder(HttpController.apiOverOrder(id: orderList[tableViewCellEditingIndexPath.row].id, stat: 2))
                orderList.removeAtIndex(tableViewCellEditingIndexPath.row)
                
                didNotFinishOrderTableView.deleteRowsAtIndexPaths([tableViewCellEditingIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
                return
            case 1:
                httpController.overOrder(HttpController.apiOverOrder(id: orderList[tableViewCellEditingIndexPath.row].id, stat: 1))
                orderList.removeAtIndex(tableViewCellEditingIndexPath.row)
                
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
