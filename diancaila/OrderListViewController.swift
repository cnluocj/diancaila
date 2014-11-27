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
    var didFinishView: UIView!
    
    var didNotFinishOrderTableView: UITableView!
    var segmentedControl: UISegmentedControl!
    
    var searchBar: UISearchBar!
    var searchController: UISearchDisplayController!
    
    var allOrderTableView: UITableView!
    
    var segmentedItems = ["未完成", "已完成"]
    
    var orderList: [[Order]] = []
    var sectionTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "订单"
        
        // 解决searchbar 抖动问题
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        loadData()

        
        segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = segmentedControl
        
        // 未完成订单界面
        didNotFinishView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didNotFinishOrderTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didNotFinishOrderTableView.delegate = self
        didNotFinishOrderTableView.dataSource = self
        didNotFinishView.addSubview(didNotFinishOrderTableView)
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
        searchBar.placeholder = "搜索"
        didNotFinishOrderTableView.tableHeaderView = searchBar
        
        // 绑定 UISearchDisplayController
        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchController.delegate = self
        
        
        self.view = didNotFinishView
        
        // 已完成订单界面
        didFinishView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didFinishView.backgroundColor = UIColor.whiteColor()
        
        
    
        allOrderTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        // 如果不加这一条，tableview会向上偏移，与手机顶部对齐
        allOrderTableView.contentInset = UIEdgeInsets(top: UIUtil.contentOffset, left: 0, bottom: 0, right: 0)
        allOrderTableView.delegate = self
        allOrderTableView.dataSource = self
        
        didFinishView.addSubview(allOrderTableView)
        
       
    }
    
    // 测试数据
    func loadData() {
        var icecreamList = [Order]()
        var meatList = [Order]()
        
        for i in 0..<10 {
            icecreamList.append(Order(menu: Menu(id: "1", name: "icecream\(i)"), deskId: 1))
            meatList.append(Order(menu: Menu(id: "1", name: "meat\(i)"), deskId: 1))
        }
        orderList.append(icecreamList)
        orderList.append(meatList)
        sectionTitles.append("icecream")
        sectionTitles.append("meat")
    }
    
    func segmentAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view = didNotFinishView
        case 1:
            self.view = didFinishView
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tableView 相关
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return orderList.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "mcell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        
        
        cell?.textLabel?.text = orderList[indexPath.section][indexPath.row].menu.name
        cell?.detailTextLabel?.text = "\(orderList[indexPath.section][indexPath.row].deskId)号桌"
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            orderList[indexPath.section].removeAtIndex(indexPath.row)
            
            if orderList[indexPath.section].count == 0 {
                orderList.removeAtIndex(indexPath.section)
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Top)
            } else {
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
