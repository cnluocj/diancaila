//
//  OrderConfirmViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/20.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderConfirmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DeskIdDelegate {
    
    var deskIdView: UITableView!
    var deskIdCell: UITableViewCell!
    
    let cellHeight =  CGFloat(42)

    var deskId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIUtil.gray_system
        self.title = "下单确认"
        
        self.deskIdView = UITableView(frame: CGRectMake(0, 40, UIUtil.screenWidth, cellHeight))
        self.deskIdView.delegate = self
        self.deskIdView.dataSource = self
        self.deskIdView.scrollEnabled = false
        self.view.addSubview(self.deskIdView)
    }
    
    func gotoDeskPickerViewController() {
        let controller = DeskPickerViewController()
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    // about tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        deskIdCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        deskIdCell.textLabel?.text = "桌号"
        if deskId == 0 {
            deskIdCell.detailTextLabel?.text = "请选择桌号"
        } else {
            deskIdCell.detailTextLabel?.text = "\(deskId)号桌"
        }
        deskIdCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return deskIdCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        gotoDeskPickerViewController()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passValue(id: Int) {
        deskId = id
        deskIdView.reloadData()
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
