//
//  InputMoneyViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/23.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

enum InputMoneyActionType {
    case plus
    case subtract
}

protocol InputMoneyViewControllerDelegate {
    func inputMoneyDidFinish()
}

class InputMoneyViewController: UIViewController, HttpProtocol, UIAlertViewDelegate {

    var textField: UITextField!
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var httpController = HttpController()
    
    var delegate: InputMoneyViewControllerDelegate?
    
    var navbar = UIUtil.navBar()
    
    var sureAlert: UIAlertView?
    
    var successAlert: UIAlertView?
    
    // 外面传进来
    var actionType = InputMoneyActionType.plus //  + 充值 - 付账
    var actionTitle: String?
    var vipId: String?
    var postUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "请输入金额"
        
        self.view.backgroundColor = UIUtil.gray_system
        
        httpController.deletage = self
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonDidPressed:")
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonDidPressed:")
//        let flexSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
//        flexSpacer.width = -10
//        self.navigationItem.leftBarButtonItems = [flexSpacer, cancelButton]
//        self.navigationItem.leftBarButtonItem = cancelButton
//        self.navigationItem.rightBarButtonItem = doneButton
        
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelButton
        navItem.rightBarButtonItem = doneButton
        navbar.pushNavigationItem(navItem, animated: false)
        
        self.view.addSubview(navbar)
        
        
        textField = UITextField(frame: CGRectMake(15, 18 + UIUtil.contentOffset, UIUtil.screenWidth - 30, 40))
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.becomeFirstResponder()
        textField.borderStyle = UITextBorderStyle.RoundedRect
        
        self.view.addSubview(textField)
    }
    
    func cancelButtonDidPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneButtonDidPressed(sender: UIBarButtonItem) {
        
        if textField.text == "" {
            println("不能为空")
        } else {
            
            sureAlert = UIAlertView(title: "确定要\(actionTitle!) \(textField.text) 元", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            sureAlert?.show()
            
            
          
        }
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView == sureAlert {
            if buttonIndex == 1 {
                waitIndicator.startAnimating()
                textField.userInteractionEnabled = false
                self.view.addSubview(waitIndicator)
                
                
                let jsonDic = NSMutableDictionary()
                switch actionType {
                case InputMoneyActionType.plus:
                    jsonDic["action"] = "+"
                case InputMoneyActionType.subtract:
                    jsonDic["action"] = "1"
                default:
                    return
                }
                jsonDic["id"] = vipId
                jsonDic["money"] = textField.text
                let defaults = NSUserDefaults.standardUserDefaults()
                jsonDic["mid"] = defaults.objectForKey("userId") as String
                httpController.post(postUrl!, json: jsonDic)
            }
            
        } else if alertView == successAlert {
            
            if buttonIndex == 0 {
                waitIndicator.removeFromSuperview()
                
                dismissViewControllerAnimated(true, completion: nil)
                delegate?.inputMoneyDidFinish()
                
            }
        }
    }
    
    // MARK: - HttpProtocol
    func didReceiveResults(result: NSDictionary) {
        let error: String? = result["error"] as? String
        if error == nil {
            
            successAlert = UIAlertView(title: "消费成功", message: "", delegate: self, cancelButtonTitle: "确定")
            successAlert?.show()
        } else {
            
            waitIndicator.stopAnimating()
            waitIndicator.removeFromSuperview()
            self.textField.userInteractionEnabled = true
            
            let alertView = UIAlertView(title: "\(error!)", message: "", delegate: nil, cancelButtonTitle: "取消")
            alertView.show()
            
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
