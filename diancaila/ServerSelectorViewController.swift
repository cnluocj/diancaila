//
//  ServerSelectorViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 15/1/4.
//  Copyright (c) 2015年 diancaila. All rights reserved.
//

import UIKit

class ServerSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIUtil.gray_system

        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HttpController.pathArray().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "")
        cell.textLabel?.text = HttpController.pathTitles()[indexPath.row]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let path = defaults.objectForKey("server") as String
        if path == HttpController.pathArray()[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let path = defaults.objectForKey("server") as String
        if path != HttpController.pathArray()[indexPath.row] {
            defaults.setObject(HttpController.pathArray()[indexPath.row], forKey: "server")
            tableView.reloadData()
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
