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
    var orderList: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "订单"
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        
        for i in 0..<10 {
            orderList.append(Order(menu: Menu(id: "1", name: "icecream\(i)"), deskId: 1))
        }
        
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
        self.view = didNotFinishView
        
        // 已完成订单界面
        didFinishView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        didFinishView.backgroundColor = UIColor.whiteColor()
        allOrderTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        allOrderTableView.contentInset = UIEdgeInsets(top: UIUtil.contentOffset, left: 0, bottom: 0, right: 0)
        allOrderTableView.delegate = self
        allOrderTableView.dataSource = self
        didFinishView.addSubview(allOrderTableView)
        
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
        allOrderTableView.tableHeaderView = searchBar
//        didFinishView.addSubview(searchBarw)
        
        // 绑定 UISearchDisplayController
        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "mcell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = orderList[indexPath.row].menu.name
        cell?.detailTextLabel?.text = "\(orderList[indexPath.row].deskId)号桌"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            orderList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
