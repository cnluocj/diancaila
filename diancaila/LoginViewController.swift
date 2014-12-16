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

        accountTF = UITextField(frame: CGRectMake(0, 0, UIUtil.screenWidth, 44))
        accountTF.text = "15122529222"
        self.view.addSubview(accountTF)
        
        pwdTF = UITextField(frame: CGRectMake(0, 45, UIUtil.screenWidth, 44))
        pwdTF.text = "123456"
        self.view.addSubview(pwdTF)
        
        loginButton = UIButton(frame: CGRectMake(15, 110, UIUtil.screenWidth - 30, 44))
        loginButton.addTarget(self, action: "loginButtonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.backgroundColor = UIUtil.flatBlue()
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        self.view.addSubview(loginButton)
    }
    
    
    func loginButtonDidPress(sender: UIButton) {
        let dic = NSMutableDictionary()
        dic["name"] = accountTF.text
        dic["pwd"] = pwdTF.text
        var data = NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        httpController.post(HttpController.apiLogin(), json: data!)
        
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.userInteractionEnabled = false
    }

    // MARK: - HttpProtocol
    func didReceiveResults(result: NSDictionary) {
        if let error = result["error"] as? String {
            println(error)
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
