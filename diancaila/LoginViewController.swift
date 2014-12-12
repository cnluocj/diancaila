//
//  LoginViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/25.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var accountTextField: UITextField!
    
    var pwdTextField: UITextField!
    
    let httpController = HttpController()
    
    // tableview 数据源
    let tableTitles = ["账号", "密码"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIUtil.gray_system
        self.title = "登陆"
        
        let navBar = UIUtil.navBar()
        self.view.addSubview(navBar)
        
//        let loginButton = UIBarButtonItem(title: "GO", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressLoginButton:")
//        
//        let navItem = UINavigationItem()
//        navItem.title = "登陆"
//        navItem.setRightBarButtonItem(loginButton, animated: false)
//        navBar.pushNavigationItem(navItem, animated: false)
        
        
        let accountLabel = UILabel(frame: CGRectMake(15, 10, 50, 24))
        accountLabel.textAlignment = NSTextAlignment.Center
        accountLabel.text = "账号"
        
        accountTextField = UITextField(frame: CGRectMake(70, 10, UIUtil.screenWidth - 70, 24))
        
        let accountView = UIView(frame: CGRectMake(0, 64, UIUtil.screenWidth, 44))
        accountView.backgroundColor = UIColor.whiteColor()
        accountView.addSubview(accountLabel)
        accountView.addSubview(accountTextField)
        
        let pwdLabel = UILabel(frame: CGRectMake(15, 10, 50, 24))
        pwdLabel.textAlignment = NSTextAlignment.Center
        pwdLabel.text = "密码"
        
        pwdTextField = UITextField(frame: CGRectMake(70, 10, UIUtil.screenWidth - 70, 24))
        
        let pwdView = UIView(frame: CGRectMake(0, 64 + 44 + 1, UIUtil.screenWidth, 44))
        pwdView.backgroundColor = UIColor.whiteColor()
        pwdView.addSubview(pwdLabel)
        pwdView.addSubview(pwdTextField)
        
        self.view.addSubview(accountView)
        self.view.addSubview(pwdView)
        
        
        
        let loginButton = UIButton(frame: CGRectMake(130, 130, 100, 100))
        loginButton.setTitle("login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "didPressLoginButton:", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.titleLabel?.textColor = UIColor.blackColor()
        self.view.addSubview(loginButton)
    }
    
    
    func didPressLoginButton(sender: UIButton) {
//        let account = accountTextField.text
//        let pwd = pwdTextField.text
//        //{"name":"15122529222","pwd":"123456"}
//        var jsonDic = [String:String]()
//        jsonDic["name"] = account
//        jsonDic["pwd"] = pwd
//        var data = NSJSONSerialization.dataWithJSONObject(jsonDic, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
//        httpController.post(HttpController.apiLogin(), json: data!)
        
        println("hello")
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
