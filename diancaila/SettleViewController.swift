//
//  SettleViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/5.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

protocol SettleViewControllerDeletage {
    func didSettle()
}

class SettleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpProtocol, UIAlertViewDelegate, UITextFieldDelegate {
    
    var contentView: UIView!
    
    var waitView = UIUtil.waitView()
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var tableView: UITableView!
    
    var textField: UITextField!
    
    var checkoutSuccessAlertView: UIAlertView?
    
    var checkUserInfoAndCheckoutAlertView: UIAlertView?
    
    var sureCheckoutAlertVeiw: UIAlertView?
    
    var orderId: String!
    
    var vipPrice: Double!
    
    var vipMoneyNotEnough = false
    
    let httpController = HttpController()
    
    var deletage: SettleViewControllerDeletage?
    
    var waitState = 0 // 用于判断 会员卡支付状态 0是第一次传，需要接收用户信息， 1是第二次确认能支付后传给服务器
    
    var vipInfo: NSDictionary?
    
    // tableview 数据源
    var checkoutType = [NSDictionary]()
    var selectedCheckoutTypeIndex = 0
    var selectedCheckoutTypeArray = [Bool]()
    
    // http id
    let httpIdWithCheckoutType = "CheckoutType"
    let httpIdWithCheckout = "Checkout"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpController.deletage = self
        
        self.view.backgroundColor = UIUtil.gray_system
        
        self.title = "结账"
        
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressCancelButton:")
        let doneButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressDoneButton:")
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
        
        contentView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset))
        self.view.addSubview(contentView)
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
        contentView.addSubview(waitView)
        
        loadCheckoutType()
    }
    
    
    func loadCheckoutType() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let shopId = defaults.objectForKey("shopId") as String
        httpController.getWithUrl(HttpController.apiCheckoutType(shopId), forIndentifier: httpIdWithCheckoutType)
    }
    
    func didPressCancelButton(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didPressDoneButton(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        
        
        let text = NSString(string: textField.text)
        
        if text == "" {
            let text = checkoutType[selectedCheckoutTypeIndex].objectForKey("input") as String
            let alert = UIAlertView(title: "", message: "\(text) 不能为空", delegate: nil, cancelButtonTitle: "好的")
            alert.show()

        } else {
            
            let checkoutTypeTitle = checkoutType[selectedCheckoutTypeIndex].objectForKey("c_name") as String
            sureCheckoutAlertVeiw = UIAlertView(title: "是否用 \(checkoutTypeTitle) 方式支付此账单", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
            sureCheckoutAlertVeiw?.show()
            
        }
        
    }
    
    func postCheckoutInfo() {
        let jsonDic = NSMutableDictionary()
        jsonDic["earn"] = textField.text
        jsonDic["phone"] = textField.text
        jsonDic["checkout_id"] = checkoutType[selectedCheckoutTypeIndex].objectForKey("id")
        jsonDic["order_id"] = orderId
        jsonDic["wait"] = waitState
        httpController.postWithUrl(HttpController.apiCheckout(), andJson: jsonDic, forIdentifier: httpIdWithCheckout)
        
        waitIndicator.startAnimating()
        self.contentView.addSubview(waitIndicator)
        self.contentView.userInteractionEnabled = false
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return checkoutType.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let checkoutCell = "checkoutCell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: checkoutCell)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = checkoutType[indexPath.row].objectForKey("c_name") as? String
            if selectedCheckoutTypeArray[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                textField = UITextField(frame: CGRectMake(15, 3, UIUtil.screenWidth - 30, cell.frame.height - 6))
                textField.delegate = self
                textField.borderStyle = UITextBorderStyle.RoundedRect
                textField.keyboardType = UIKeyboardType.NumberPad
                cell.addSubview(textField)
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0 {
            if !selectedCheckoutTypeArray[indexPath.row] {
                selectedCheckoutTypeArray[indexPath.row] = true
                selectedCheckoutTypeArray[selectedCheckoutTypeIndex] = false
                selectedCheckoutTypeIndex = indexPath.row
                
                tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "请选择支付方式"
        } else if section == 1 {
            if checkoutType.count > 0 {
                return checkoutType[selectedCheckoutTypeIndex].objectForKey("input") as? String
            }
        }
        return ""
    }
    
    
    // MARK: - HttpProtocol
    func httpControllerDidReceiveResult(result: NSDictionary, forIdentifier identifier: String) {
        switch identifier {
        case httpIdWithCheckoutType:
            didReceiveCheckoutType(result)
        case httpIdWithCheckout:
            didReceiveResults(result)
        default:
            return
        }
    }
    
    
    func didReceiveCheckoutType(result: NSDictionary) {
        let error = result["error"] as? String
        if error == nil {
            let data = result["checkout_type"] as NSArray
            for type in data {
                let temp = type as NSDictionary
                checkoutType.append(temp)
                selectedCheckoutTypeArray.append(false)
            }
            if selectedCheckoutTypeArray.count > 0 {
                selectedCheckoutTypeArray[0] = true
            }
            
            waitView.removeFromSuperview()
            
            tableView.reloadData()
        } else {
            println(error)
        }
    }
    
    func didReceiveResults(result: NSDictionary) {
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.contentView.userInteractionEnabled = true
        
        let error = result["error"] as? String
        if error == nil {
            
            vipInfo = result["user_info"] as? NSDictionary
            println(vipInfo)
            
            if vipInfo == nil {
                checkoutSuccessAlertView = UIAlertView(title: "消费成功", message: "", delegate: self, cancelButtonTitle: "确定")
                checkoutSuccessAlertView?.show()
            } else {
                let name = vipInfo?.objectForKey("name") as String
                let id = vipInfo?.objectForKey("id") as String
                let moneyString = vipInfo?.objectForKey("money") as? NSString
                let money2String = vipInfo?.objectForKey("money2") as? NSString
                
                if moneyString == nil {
                    let message = "\(name) \n未开卡"
                    checkUserInfoAndCheckoutAlertView = UIAlertView(title: "账户信息", message: message, delegate: nil, cancelButtonTitle: "确定")
                    checkUserInfoAndCheckoutAlertView?.show()
                    
                } else {
                    let money = moneyString?.doubleValue
                    let money2 = money2String?.doubleValue
                    if money! + money2! >= vipPrice {
                        let message = "\(name) \n余额: \(money!) \n返现: \(money2!)"
                        checkUserInfoAndCheckoutAlertView = UIAlertView(title: "账户信息", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                        checkUserInfoAndCheckoutAlertView?.show()
                    } else {
                        vipMoneyNotEnough = true
                        
                        let message = "\(name) \n余额: \(money!) \n返现: \(money2!)"
//                        checkUserInfoAndCheckoutAlertView = UIAlertView(title: "账户信息", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "余额不足请充值")
                        checkUserInfoAndCheckoutAlertView = UIAlertView(title: "账户信息", message: message, delegate: self, cancelButtonTitle: "余额不足请充值")
                        checkUserInfoAndCheckoutAlertView?.show()
                    }
                }
                
               
            }
            
        } else {
            
            let alertView = UIAlertView(title: error, message: "", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == checkoutSuccessAlertView {
            if buttonIndex == 0 {
                
                self.navigationController?.popViewControllerAnimated(true)
                deletage?.didSettle()
                
            }
        } else if alertView == checkUserInfoAndCheckoutAlertView {
            if vipMoneyNotEnough {
                if buttonIndex == 1 {
                    let vc = VipDetailViewController()
                    vc.vipInfo = vipInfo
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } else {
                if buttonIndex == 1 {
                    waitState = 1
                    postCheckoutInfo()
                } else {
                    waitState = 0
                }
            }
            
        } else if alertView == sureCheckoutAlertVeiw {
            if buttonIndex == 1 {
                postCheckoutInfo()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let board = UIButton(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        board.addTarget(self, action: "keyboardHide:", forControlEvents: UIControlEvents.TouchUpInside)
        board.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(board)
        
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -100)
        })
        
        
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        return true
    }
    
    func keyboardHide(sender: UIButton) {
        textField.resignFirstResponder()
        sender.removeFromSuperview()
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
