//
//  SettingsTableViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/16.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomActionSheetDelegate {
    
    var tableView: UITableView!
    
    let titles = [["账号与安全"], ["新消息通知", "通用"], ["关于点菜啦"], ["退出登录"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIUtil.gray_system
        
        self.title = "设置"

        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset - 50), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func gotoLoginVC() {
        let loginVC = LoginViewController()
        let nav = UIUtil.navController()
        nav.pushViewController(loginVC, animated: false)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        let mcell = "settingsCell"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: mcell)
        cell.textLabel?.text = titles[indexPath.section][indexPath.row]
        
        if indexPath.section == titles.count - 1 {
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let label = UILabel(frame: CGRectMake(20, 0, UIUtil.screenWidth - 40, 100))
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFontOfSize(14)
        label.text = "退出后将清除登陆信息，是否继续退出登录"
        label.textAlignment = NSTextAlignment.Center
        let actionSheet = CustomActionSheet(customView: label)
        actionSheet.deletage = self
        actionSheet.show()
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    // MARK: - CustomActionSheetDelegate
    func didPressDoneButton(view: UIView) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("account")
        defaults.removeObjectForKey("password")
        
        gotoLoginVC()
    }
}
