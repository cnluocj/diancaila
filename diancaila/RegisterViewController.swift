//
//  RegisterViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/16.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, HttpProtocol {
    
    var phoneNumberTF: UITextField!
    var nameTF: UITextField!
    var pwdTF: UITextField!
    var pwdTF2: UITextField!
    
    var registerButton: UIButton!
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var httpController = HttpController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpController.deletage = self
        
        self.view.backgroundColor = UIUtil.gray_system
        self.title = "注册"

        phoneNumberTF = UITextField(frame: CGRectMake(15, 10, UIUtil.screenWidth - 30, 44))
        phoneNumberTF.keyboardType = UIKeyboardType.PhonePad
        changeStyleForTextField(phoneNumberTF, placeholder: "请输入手机号")
        self.view.addSubview(phoneNumberTF)
        
        nameTF = UITextField(frame: CGRectMake(15, 64, UIUtil.screenWidth - 30, 44))
        changeStyleForTextField(nameTF, placeholder: "请输入姓名")
        self.view.addSubview(nameTF)
        
        pwdTF = UITextField(frame: CGRectMake(15, 118, UIUtil.screenWidth - 30, 44))
        pwdTF.secureTextEntry = true
        changeStyleForTextField(pwdTF, placeholder: "请输入密码")
        self.view.addSubview(pwdTF)
        
        pwdTF2 = UITextField(frame: CGRectMake(15, 172, UIUtil.screenWidth - 30, 44))
        pwdTF2.secureTextEntry = true
        changeStyleForTextField(pwdTF2, placeholder: "请再次输入密码")
        self.view.addSubview(pwdTF2)
        
        registerButton = UIButton(frame: CGRectMake(15, 226, UIUtil.screenWidth - 30, 44))
        registerButton.backgroundColor = UIUtil.flatBlue()
        registerButton.setTitle("注册", forState: UIControlState.Normal)
        registerButton.layer.cornerRadius = 5
        registerButton.addTarget(self, action: "registerButtonDidPress:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(registerButton)
    }
    
    func registerButtonDidPress(sender: UIButton) {
        let phoneNumber = phoneNumberTF.text
        let name = nameTF.text
        let pwd = pwdTF.text
        let pwd2 = pwdTF2.text
        
        if phoneNumber == "" || name == "" || pwd == "" || pwd2 == "" {
            println("不能为空")
            return
        }
        
        if pwd != pwd2 {
            println("两次密码不一致")
            return
        }
        
        let dic = NSMutableDictionary()
        dic["name"] = phoneNumber
        dic["pwd"] = pwd
        dic["realname"] = name
        var data = NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        httpController.post(HttpController.apiRegister(), json: data!)
        
        
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.userInteractionEnabled = false
    }

    func changeStyleForTextField(textField: UITextField, placeholder: String) {
        textField.textAlignment = NSTextAlignment.Center
        textField.placeholder = placeholder
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIUtil.flatBlue().CGColor
        textField.layer.cornerRadius = 5
    }
    
    // MARK: - HttpProtocol
    func didReceiveResults(result: NSDictionary) {
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
            println(result)
        if let error = result["error"] as? String {
            println(error)
        } else {
            let state = result["state"] as Int
            if state == 0 {
                println("注册错误，请重新注册")
            } else {
                
                println("注册成功")
                
                self.navigationController?.popViewControllerAnimated(true)
                
            }
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
