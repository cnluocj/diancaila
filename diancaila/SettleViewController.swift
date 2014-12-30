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
    
    var checkoutSuccessAlertView: UIAlertView?
    
    var checkUserInfoAndCheckoutAlertView: UIAlertView?
    
    var sureCheckoutAlertVeiw: UIAlertView?
    
    var bottomTextField: UITextField!
    
    var bottomView: UIView!
    
    var board: UIButton? // 键盘弹出后面的挡板
    
    
    var orderId: String!
    
    // VIP价
    var vipPrice: Double!
    
    // 原价
    var price: Double!
    
    // 代金券后仍需付帐
    var stillPrice: Double!
    
    var vipMoneyNotEnough = false
    
    let httpController = HttpController()
    
    var deletage: SettleViewControllerDeletage?
    
    var waitState = 0 // 用于判断 会员卡支付状态 0是第一次传，需要接收用户信息， 1是第二次确认能支付后传给服务器
    
    // 代金券相关
    var voucherIndex: Int?
    var voucherSelectedNum = 0
    var stepperArray = [UIStepper]()
    
    // vip用户信息
    var vipInfo: NSDictionary?
    
    
    
    // tableview 数据源 ----------------
    var checkoutType = [NSDictionary]()
    var selectedCheckoutTypeIndex = 0
    var selectedCheckoutTypeArray = [Bool]()
    var sectionHeadTitle = ["请选择支付方式"]
    // 代金券 array
    var voucherList = [Voucher]()
    
    // http id ------------------------
    let httpIdWithCheckoutType = "CheckoutType"
    let httpIdWithCheckout = "Checkout"
    let httpIdWithCheckoutInfo = "CheckoutInfo"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpController.deletage = self
        
        self.view.backgroundColor = UIUtil.gray_system
        
        self.title = "结账"
        
        // 初始等于原价
        stillPrice = price
        
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressCancelButton:")
        let doneButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressDoneButton:")
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
        
        contentView = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset))
        self.view.addSubview(contentView)
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset - 50), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
        contentView.addSubview(waitView)
        
        
        bottomView = UIView(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 50, UIUtil.screenWidth, 50))
        bottomView.backgroundColor = UIUtil.gray
        contentView.addSubview(bottomView)
        
        bottomTextField = UITextField(frame: CGRectMake(15, 7, UIUtil.screenWidth - 30, 36))
        bottomTextField.keyboardType = UIKeyboardType.NumberPad
        bottomTextField.borderStyle = UITextBorderStyle.RoundedRect
        bottomView.addSubview(bottomTextField)
        
        let devide = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 1))
        devide.backgroundColor = UIColor.grayColor()
        devide.alpha = 0.3
        bottomView.addSubview(devide)
        
        let devide2 = UIView(frame: CGRectMake(0, 49, UIUtil.screenWidth, 1))
        devide2.backgroundColor = UIColor.grayColor()
        devide2.alpha = 0.3
        bottomView.addSubview(devide2)
        
        // 获取键盘高度
        //增加监听，当键盘出现或改变时收出消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        //增加监听，当键退出时收出消息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        loadCheckoutType()
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: Dictionary? = notification.userInfo
        let value: NSValue = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        let keyboardRect = value.CGRectValue()
        let height = keyboardRect.size.height
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.bottomView.frame.origin = CGPoint(x: 0, y: UIUtil.screenHeight - UIUtil.contentOffset - height - 50)
        })
        
        board = UIButton(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset - height - 50))
        board!.addTarget(self, action: "keyboardHide:", forControlEvents: UIControlEvents.TouchUpInside)
        board!.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(board!)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.bottomView.frame.origin = CGPoint(x: 0, y: UIUtil.screenHeight - UIUtil.contentOffset - 50)
        })
        
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
        board?.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        
        
        let text = NSString(string: bottomTextField.text)
        
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
        var count = 0.0
        for voucher in voucherList {
                count = count + (Double(voucher.num) * voucher.realValue)
        }
        
        let jsonDic = NSMutableDictionary()
        jsonDic["earn"] = NSString(string: bottomTextField.text).doubleValue + count
        jsonDic["phone"] = bottomTextField.text
        jsonDic["checkout_id"] = checkoutType[selectedCheckoutTypeIndex].objectForKey("id")
        jsonDic["order_id"] = orderId
        jsonDic["wait"] = waitState
        let defaults = NSUserDefaults.standardUserDefaults()
        let userId = defaults.objectForKey("userId") as String
        jsonDic["user_id"] = userId
        
        println(jsonDic)
        httpController.postWithUrl(HttpController.apiCheckout(), andJson: jsonDic, forIdentifier: httpIdWithCheckout)
        
        waitIndicator.startAnimating()
        self.contentView.addSubview(waitIndicator)
        self.contentView.userInteractionEnabled = false
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeadTitle.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return checkoutType.count
        } else {
            return voucherList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let checkoutCell = "checkoutCell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: checkoutCell)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = checkoutType[indexPath.row].objectForKey("c_name") as? String
            if selectedCheckoutTypeArray[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        } else {
            if voucherList.count > 0 {
                cell.textLabel?.text = voucherList[indexPath.row].name
                
                stepperArray[indexPath.row].frame.origin = CGPoint(x: UIUtil.screenWidth - 100, y: 7)
                stepperArray[indexPath.row].addTarget(self, action: "valueChangeAction:", forControlEvents: UIControlEvents.ValueChanged)
                cell.contentView.addSubview(stepperArray[indexPath.row])
                
                
                let numLabel = UILabel(frame: CGRectMake(UIUtil.screenWidth - 150, 0, 50, 44))
                numLabel.textAlignment = NSTextAlignment.Center
                numLabel.text = "\(voucherList[indexPath.row].num) 张"
                cell.contentView.addSubview(numLabel)
            }
        }
        
        
        return cell
    }
    
    func valueChangeAction(sender: UIStepper) {
        let num = stepperArray.count
        for i in 0 ..< num {
            if stepperArray[i] == sender {
                if Int(sender.value) > voucherList[i].maxNum {
                   sender.value = Double(voucherList[i].maxNum)
                   return
                }
                
                if Int(sender.value) < voucherList[i].num {
                    println("<")
                    voucherList[i].num = Int(sender.value)
                    stillPrice = stillPrice + voucherList[i].voucherValue
                } else {
                    
                    if stillPrice == 0 {
                        sender.value = Double(voucherList[i].num)
                        return
                    }
                    
                    let tempPrice = stillPrice - voucherList[i].voucherValue
                    if tempPrice < 0 {
                        stillPrice = 0
                    } else {
                        stillPrice = tempPrice
                    }
                }
                
                
                voucherList[i].num = Int(sender.value)
                tableView.reloadData()
                bottomTextField.placeholder = "仍需付 ¥ \(stillPrice)"
                return
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 0 {
            
            voucherList.removeAll(keepCapacity: false)
            sectionHeadTitle = ["请选择支付方式"]
            
            if !selectedCheckoutTypeArray[indexPath.row] {
                selectedCheckoutTypeArray[indexPath.row] = true
                selectedCheckoutTypeArray[selectedCheckoutTypeIndex] = false
                selectedCheckoutTypeIndex = indexPath.row
                
                tableView.reloadData()
                
                bottomTextField.placeholder = checkoutType[selectedCheckoutTypeIndex].objectForKey("input") as? String
                
                waitIndicator.startAnimating()
                self.view.addSubview(waitIndicator)
                self.view.userInteractionEnabled = false
                
                let dic = NSMutableDictionary()
                dic["id"] = checkoutType[indexPath.row].objectForKey("id")
                let defaults = NSUserDefaults.standardUserDefaults()
                dic["clerk_shop_id"] = defaults.objectForKey("shopId") as String
                httpController.postWithUrl(HttpController.apiCheckInfo(), andJson: dic, forIdentifier: httpIdWithCheckoutInfo)
            }
        } else if indexPath.section == 1 {
            if voucherList.count > 0 {
                
                // todo 暂时没用
                voucherIndex = indexPath.row
                
                
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeadTitle[section]
    }
    
    
    // MARK: - HttpProtocol
    func httpControllerDidReceiveResult(result: NSDictionary, forIdentifier identifier: String) {
        switch identifier {
        case httpIdWithCheckoutType:
            didReceiveCheckoutType(result)
        case httpIdWithCheckout:
            didReceiveResults(result)
        case httpIdWithCheckoutInfo:
            checkoutInfoDidReceive(result)
            
        default:
            return
        }
    }
    
    func checkoutInfoDidReceive(result: NSDictionary) {
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
        println(result)
        let error = result["error"] as? String
        if error == nil {
            let voucherInfo = result["voucher_info"] as? NSArray
            
            // 如果是代金券信息
            if let array = voucherInfo {
                
                for voucher in array {
                    let temp = voucher as NSDictionary
                    let id = temp["voucher_id"] as String
                    let isOnline = (temp["voucher_online"] as String) == "1" ? true : false
                    let realValue = (temp["voucher_real_value"] as NSString).doubleValue
                    let voucherValue = (temp["voucher_value"] as NSString).doubleValue
                    let shopId = temp["voucher_shop_id"] as String
                    let name = temp["voucher_name"] as String
                    let maxNum = (temp["voucher_maxnum"] as NSString).integerValue
                    
                    let vou = Voucher(id: id, name: name, isOnline: isOnline, realValue: realValue, voucherValue: voucherValue, shopId: shopId, maxNum: maxNum)
                    voucherList.append(vou)
                    
                    stepperArray.append(UIStepper())
                }
                
                bottomTextField.placeholder = "仍需付 ¥ \(stillPrice)"
                
                sectionHeadTitle = ["请选择支付方式", "请选择代金券数量"]
                tableView.reloadData()
            }
            
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
            
            bottomTextField.placeholder = checkoutType[selectedCheckoutTypeIndex].objectForKey("input") as? String
            
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
                        
                        vipMoneyNotEnough = false
                        
                        let message = "\(name) \n余额: \(money!) \n返现: \(money2!)"
                        checkUserInfoAndCheckoutAlertView = UIAlertView(title: "账户信息", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                        checkUserInfoAndCheckoutAlertView?.show()
                        
                    } else {
                        
                        vipMoneyNotEnough = true
                        
                        let message = "\(name) \n余额: \(money!) \n返现: \(money2!)"
                        checkUserInfoAndCheckoutAlertView = UIAlertView(title: "账户信息", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "余额不足请充值")
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
        
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
     
        
        return true
    }
    
    func keyboardHide(sender: UIButton) {
        bottomTextField.resignFirstResponder()
        sender.removeFromSuperview()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        waitState = 0
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
