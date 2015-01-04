//
//  WaiterViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/19.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class WaiterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VipNumInputModelViewControllerDelegate {
    
    var tableView: UITableView!
    
    // tableView 数据源
    let titles = [["会员"], ["服务器"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "服务员"
        
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

    }
    
    func gotoServerSelectorVC() {
        let serverVC = ServerSelectorViewController()
        self.navigationController?.pushViewController(serverVC, animated: true)
    }
    
    func gotoVipNumInputMVC() {
        let vipNumInputMVC = VipNumInputModelViewController()
        vipNumInputMVC.delegate = self
        self.presentViewController(vipNumInputMVC, animated: true, completion: nil)
    }
    
    func gotoVipDetailVC(vipInfo: NSDictionary) {
        let vipDetailVC = VipDetailViewController()
        vipDetailVC.vipInfo = vipInfo
        self.navigationController?.pushViewController(vipDetailVC, animated: true)
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
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: mcell)
        }
        cell?.textLabel?.text = titles[indexPath.section][indexPath.row]
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                gotoVipNumInputMVC()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                gotoServerSelectorVC()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: VipNumInputModelViewControllerDelegate
    func receiveVipInfo(info: NSDictionary) {
        gotoVipDetailVC(info)
    }

}
