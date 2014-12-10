//
//  LoginViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/25.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var loginTableView: UITableView!
    
    // tableview 数据源
    let tableTitles = ["账号", "密码"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Login"
        
//        let loginButton = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
        let loginButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = loginButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = cancelButton
        
        loginTableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight), style: UITableViewStyle.Grouped)
        loginTableView.scrollEnabled = false
        loginTableView.delegate = self
        loginTableView.dataSource = self
        self.view.addSubview(loginTableView)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let loginCell = "loginCell"
        
        let cell = TextFieldTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: loginCell)
        
        cell.titleLabel.text = tableTitles[indexPath.row]
        if indexPath.row == 1 {
            cell.textField.secureTextEntry = true
        }
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
