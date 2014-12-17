//
//  DiscoverViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/10.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    let titles = ["附近", "吃货圈", "游戏"]
    
    let imageNames = ["location", "waiter", "game"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发现"
        
        self.view.backgroundColor = UIUtil.gray_system
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mcell = "mcell"
//        let cell = IconTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: mcell, image: UIImage(named: imageNames[indexPath.row])!, title: titles[indexPath.row], detailTitle: "后厨正在备菜，敬请期待...")
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mcell")
        cell.textLabel?.text = titles[indexPath.row]
        cell.detailTextLabel?.text = "后厨正在备菜，敬请期待..."
        cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
//        cell.mDetailTitleLabel?.textColor = UIColor.grayColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
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
