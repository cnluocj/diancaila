//
//  LoginViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/16.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, HttpProtocol, JSONParseProtocol {
    
    var accountTF: UITextField!
    var accountLabel: UILabel!
    
    var pwdTF: UITextField!
    var pwdLabel: UILabel!
    
    var loginButton: UIButton!
    
    var registerButton: UIButton!
    
    var waitIndicator = UIUtil.waitIndicator()
    
    let httpController = HttpController()
    
    let jsonController = JSONController()
    
    var user: User!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录"
        
        self.view.backgroundColor = UIUtil.gray_system
        
        httpController.deletage = self
        
        jsonController.parseDelegate = self

        accountTF = UITextField(frame: CGRectMake(15, 10, UIUtil.screenWidth - 30, 44))
        accountTF.keyboardType = UIKeyboardType.PhonePad
        accountTF.text = "15122529222"
        accountTF.textAlignment = NSTextAlignment.Center
        accountTF.placeholder = "请输入手机号"
        accountTF.clearButtonMode = UITextFieldViewMode.WhileEditing
        accountTF.layer.borderWidth = 2
        accountTF.layer.borderColor = UIUtil.flatBlue().CGColor
        accountTF.layer.cornerRadius = 5
        self.view.addSubview(accountTF)
        
        pwdTF = UITextField(frame: CGRectMake(15, 65, UIUtil.screenWidth - 30, 44))
        pwdTF.text = "123456"
        pwdTF.secureTextEntry = true
        pwdTF.placeholder = "请输入密码"
        pwdTF.clearButtonMode = UITextFieldViewMode.WhileEditing
        pwdTF.textAlignment = NSTextAlignment.Center
        pwdTF.layer.borderWidth = 2
        pwdTF.layer.borderColor = UIUtil.flatBlue().CGColor
        pwdTF.layer.cornerRadius = 5
        self.view.addSubview(pwdTF)
        
        loginButton = UIButton(frame: CGRectMake(15, 120, UIUtil.screenWidth - 30, 44))
        loginButton.addTarget(self, action: "loginButtonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.backgroundColor = UIUtil.flatBlue()
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.layer.cornerRadius = 5
        self.view.addSubview(loginButton)
        
        
        registerButton = UIButton(frame: CGRectMake(UIUtil.screenWidth/2 - 75, 174, 150, 30))
        registerButton.titleLabel?.textAlignment = NSTextAlignment.Center
        registerButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        registerButton.setTitle("没有账号？注册吧", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIUtil.flatBlue(), forState: UIControlState.Normal)
        registerButton.addTarget(self, action: "registerButtonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(registerButton)
    }
    
    func registerButtonDidPress(sender: UIButton) {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func loginButtonDidPress(sender: UIButton) {
        let dic = NSMutableDictionary()
        dic["name"] = accountTF.text
        dic["pwd"] = pwdTF.text
        httpController.post(HttpController.apiLogin(), json: dic)
        
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.userInteractionEnabled = false
    }

    // MARK: - HttpProtocol
    func didReceiveResults(result: NSDictionary) {
        if let error = result["error"] as? String {
            println(error)
            
            waitIndicator.stopAnimating()
            waitIndicator.removeFromSuperview()
            self.view.userInteractionEnabled = true
            
        } else {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(accountTF.text, forKey: "account")
            defaults.setObject(pwdTF.text, forKey: "password")
            
            jsonController.parseUserInfo(result)
        }
    }
    
    // MARK: - JSONParseProtocol
    func didFinishParseUserInfo(user: User) {
        waitIndicator.userInteractionEnabled = true
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        
        self.user = user
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(user.shopId, forKey: "shopId")
        defaults.setObject(user.id, forKey: "userId")
        
        
        let homeVC = HomeViewController()
        homeVC.isFirstLogin = true
        homeVC.setUser(user)
        self.presentViewController(homeVC, animated: true, completion: nil)
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
