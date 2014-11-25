//
//  LoginViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/25.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var userLabel: UILabel!
    var pwdLabel: UILabel!
    var userTextField: UITextField!
    var pwdTextField: UITextField!
    
    // 点五次login可以登录
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Login"
        
        
        userLabel = UILabel(frame: CGRectMake(50, 50, 100, 30))
        userLabel.text = "username"
        self.view.addSubview(userLabel)
        
        userTextField = UITextField(frame: CGRectMake(150, 45, 100, 40))
        userTextField.borderStyle = UITextBorderStyle.RoundedRect
        userTextField.clearButtonMode = UITextFieldViewMode.Always
        self.view.addSubview(userTextField)
        
        pwdLabel = UILabel(frame: CGRectMake(50, 100, 100, 30))
        pwdLabel.text = "password"
        self.view.addSubview(pwdLabel)
        
        pwdTextField = UITextField(frame: CGRectMake(150, 95, 100, 40))
        pwdTextField.clearButtonMode = UITextFieldViewMode.Always
        pwdTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(pwdTextField)
        
        let loginButton: UIButton = UIButton(frame: CGRectMake(50, 150, UIUtil.screenWidth - 100,40))
        loginButton.backgroundColor = UIColor.orangeColor()
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "didPressLoginButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)
        
    }
    
    func didPressLoginButton(sender: UIButton) {
        if ++count >= 5 {
            let viewController = ViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
