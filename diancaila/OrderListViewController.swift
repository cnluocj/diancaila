//
//  OrderListViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/26.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UISearchDisplayDelegate {
    
    var didNotFinishView: UIView!
    var allOrderView: UIView!
    
    var didNotFinishOrderTableView: UITableView!
    var segmentedControl: UISegmentedControl!
    
    var searchBar: UISearchBar!
    var searchController: UISearchDisplayController!
    
    var allOrderTableView: UITableView!
    
    var segmentedItems = ["等待订单", "全部订单"]
    
    // 数据源
    var orderList: [[Order]] = []
    var sectionTitles = [String]()
    var searchData = NSMutableArray() // orderList 一维表示
    var filterData: NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单"
            
        // 解决searchbar 抖动问题
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        loadData()

        
        segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = segmentedControl
        
        // 未完成订单界面 ---------------------------------------------------------------------------
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
        
        // 已完成订单界面 -----------------------------------------------------------------------
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
    
    // 测试数据
    func loadData() {
        var icecreamList = [Order]()
        var meatList = [Order]()
        
        for i in 0..<10 {
            icecreamList.append(Order(menuTypeIndex: 0, menuIndex: i, menu: Menu(id: "1", name: "icecream\(i)"), deskId: 1))
            meatList.append(Order(menuTypeIndex: 1, menuIndex: i, menu: Menu(id: "1", name: "肉类啊\(i)"), deskId: 1))
        }
        orderList.append(icecreamList)
        orderList.append(meatList)
        sectionTitles.append("icecream")
        sectionTitles.append("meat")
        

        reloadSearchData(orderList)
    }
    
    
    // 重载提供搜索的数据
    func reloadSearchData(list: [[Order]]) {
        searchData.removeAllObjects()
        
        // 将二维的orderList 化作一维
        for sectionData in orderList {
            for indexData in sectionData {
                searchData.addObject(indexData)
            }
        }
    }
    
    
    
    func segmentAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view = didNotFinishView
        case 1:
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
        if tableView == didNotFinishOrderTableView {
            return orderList.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == didNotFinishOrderTableView {
            return sectionTitles[section]
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == didNotFinishOrderTableView {
            return orderList[section].count
        } else {
            
            // 谓词搜索
            let predicate = NSPredicate(format: "menu.name contains [cd] %@", searchController.searchBar.text)
            filterData =  NSArray(array: searchData.filteredArrayUsingPredicate(predicate!))
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
            cell?.textLabel?.text = orderList[indexPath.section][indexPath.row].menu.name
            cell?.detailTextLabel?.text = "\(orderList[indexPath.section][indexPath.row].deskId)号桌"
            
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
                
                orderList[indexPath.section].removeAtIndex(indexPath.row)
                reloadSearchData(orderList)
                
                if orderList[indexPath.section].count == 0 {
                    orderList.removeAtIndex(indexPath.section)
                    tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Top)
                } else {
                    
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                    
                }
                
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if tableView == searchController.searchResultsTableView {
            searchController.setActive(false, animated: true)
            
            let order: Order = filterData?.objectAtIndex(indexPath.row) as Order
            let outSideIndexPath = NSIndexPath(forRow: order.menuIndex, inSection: order.menuTypeIndex)
            didNotFinishOrderTableView.scrollToRowAtIndexPath(outSideIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView == didNotFinishOrderTableView {
//            let view =  UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 40))
//            view.backgroundColor = UIUtil.gray_system
//            let titleLabel = UILabel(frame: CGRectMake(0, 3, UIUtil.screenWidth, 20))
//            titleLabel.font = UIFont.systemFontOfSize(20)
//            titleLabel.backgroundColor = UIColor.clearColor()
//            titleLabel.textColor = UIColor.orangeColor()
//            titleLabel.text = sectionTitles[section]
//            titleLabel.textAlignment = NSTextAlignment.Center
//            view.addSubview(titleLabel)
//            return view
//        }
//        
//        return nil
//    }
//    
    
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
