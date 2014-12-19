//
//  WaiterViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/19.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class WaiterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    // tableView 数据源
    let titles = [["会员"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "服务员"
        
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

    }
    
    
    func gotoVipNumInputMVC() {
        let vipNumInputMVC = VipNumInputModelViewController()
        self.presentViewController(vipNumInputMVC, animated: true, completion: nil)
    }
    
    // MARK : UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mcell = "mcell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(mcell) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: mcell)
        }
        cell?.textLabel?.text = titles[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                gotoVipNumInputMVC()
            }
        }
    }

}
