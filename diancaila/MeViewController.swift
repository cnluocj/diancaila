//
//  MeViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/10.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    let titles = ["相册", "收藏", "钱包"]
    
    let imageNames = ["picture", "box", "wallet"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我"
        
        self.view.backgroundColor = UIColor.whiteColor()

        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoLogin() {
        let loginCV = LoginViewController()
//        let nav = UIUtil.navController(loginCV)
        self.presentViewController(loginCV, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return titles.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userInfoCell = "userInfoCell"
        let imageCell = "imageCell"
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell = UserInfoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: userInfoCell, image: UIImage(named: "iron_man")!, title: "钢铁侠", detailTitle: "啦号: 1234567890")
            
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell = IconTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: imageCell, image: UIImage(named: "settings")!, title: "设置")
            
        }else {
            cell = IconTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: imageCell, image: UIImage(named: imageNames[indexPath.row])!, title: titles[indexPath.row])
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
//        gotoLogin()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 90
        } else {
            return 44
        }
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
