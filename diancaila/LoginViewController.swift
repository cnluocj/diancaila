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
        self.title = "登陆"
        
        let navBar = UIUtil.navBar()
        self.view.addSubview(navBar)
        
        let loginButton = UIBarButtonItem(title: "GO", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressLoginButton:")
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "didPressCancelButton:")
        
        let navItem = UINavigationItem()
        navItem.title = "登陆"
        navItem.setLeftBarButtonItem(cancelButton, animated: false)
        navItem.setRightBarButtonItem(loginButton, animated: false)
        navBar.pushNavigationItem(navItem, animated: false)
        
            
        loginTableView = UITableView(frame: CGRectMake(0, 60, UIUtil.screenWidth, UIUtil.screenHeight), style: UITableViewStyle.Grouped)
        loginTableView.scrollEnabled = false
        loginTableView.delegate = self
        loginTableView.dataSource = self
        self.view.addSubview(loginTableView)
        
    }
    
    
    func didPressCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didPressLoginButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func getNavController() ->UINavigationController{
        let navController = UINavigationController()
        //20为iphone状态栏高度
        let navImage = UIUtil.imageFromColor(UIUtil.screenWidth, height: navController.navigationBar.frame.height+20, color: UIUtil.navColor)
        // 改变背景颜色，使用生成的纯色图片
        navController.navigationBar.setBackgroundImage(navImage, forBarMetrics: UIBarMetrics.Default)
        // 主体是否从顶部开始/是否透明
        navController.navigationBar.translucent = false
        // 改变title颜色
        navController.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        // 改变导航栏上字体颜色，除了title
        navController.navigationBar.tintColor = UIColor.whiteColor()
        return navController
    }
    
    // MARK: - Table view data source
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
