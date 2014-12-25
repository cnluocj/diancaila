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

class SettleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpProtocol, UIAlertViewDelegate {
    
    var contentView: UIView!
    
    var waitView = UIUtil.waitView()
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var tableView: UITableView!
    
    var textField: UITextField!
    
    var checkoutSuccessAlertView: UIAlertView?
    
    var orderId: String!
    
    let httpController = HttpController()
    
    var deletage: SettleViewControllerDeletage?
    
    // tableview 数据源
    var checkoutType = [NSDictionary]()
    var selectedCheckoutTypeIndex = 0
    var selectedCheckoutTypeArray = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpController.deletage = self
        
        self.view.backgroundColor = UIUtil.gray_system
        
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, UIUtil.screenWidth, 44 + UIUtil.statusHeight))
        navBar.backgroundColor = UIUtil.navColor
        
        //22为iphone状态栏高度
        let navImage = UIUtil.imageFromColor(UIUtil.screenWidth, height: 44 + UIUtil.statusHeight, color: UIUtil.navColor)
        // 改变背景颜色，使用生成的纯色图片
        navBar.setBackgroundImage(navImage, forBarMetrics: UIBarMetrics.Default)
        // 主体是否从顶部开始
        navBar.translucent = false
        // 改变title颜色
        navBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        // 改变导航栏上字体颜色，除了title
        navBar.tintColor = UIColor.whiteColor()
        
        let navitem = UINavigationItem(title: "结账")
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressCancelButton:")
        let doneButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressDoneButton:")
        navitem.setLeftBarButtonItem(cancelButton, animated: false)
        navitem.setRightBarButtonItem(doneButton, animated: false)
        
        navBar.pushNavigationItem(navitem, animated: false)
        
        self.view.addSubview(navBar)
        
        
        contentView = UIView(frame: CGRectMake(0, UIUtil.contentOffset, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset))
        self.view.addSubview(contentView)
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
//        priceField = UITextField(frame: CGRectMake(10, 120, self.view.frame.width - 20, 40))
//        priceField.borderStyle = UITextBorderStyle.RoundedRect
//        priceField.placeholder = "输入实际金额"
//        priceField.keyboardType = UIKeyboardType.NumberPad
//        priceField.becomeFirstResponder()
//        self.view.addSubview(priceField)
        
        contentView.addSubview(waitView)
        loadCheckoutType()
    }
    
    
    func loadCheckoutType() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let shopId = defaults.objectForKey("shopId") as String
        httpController.onSearchCheckoutType(HttpController.apiCheckoutType(shopId))
    }
    
    func didPressCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didPressDoneButton(sender: UIBarButtonItem) {
        
        let text = NSString(string: textField.text)
        
        if text == "" {
            let text = checkoutType[selectedCheckoutTypeIndex].objectForKey("input") as String
            let alert = UIAlertView(title: "", message: "\(text) 不能为空", delegate: nil, cancelButtonTitle: "好的")
            alert.show()

        } else {
            
            let jsonDic = NSMutableDictionary()
            jsonDic["earn"] = text
            jsonDic["checkout_id"] = checkoutType[selectedCheckoutTypeIndex].objectForKey("id")
            jsonDic["order_id"] = orderId
            httpController.post(HttpController.apiCheckout(), json: jsonDic)
            
            waitIndicator.startAnimating()
            self.contentView.addSubview(waitIndicator)
            self.contentView.userInteractionEnabled = false
            
        }
        
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
                textField.borderStyle = UITextBorderStyle.RoundedRect
                textField.keyboardType = UIKeyboardType.NumberPad
                textField.becomeFirstResponder()
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
            checkoutSuccessAlertView = UIAlertView(title: "消费成功", message: "", delegate: self, cancelButtonTitle: "确定")
            checkoutSuccessAlertView?.show()
            
        } else {
            
            let alertView = UIAlertView(title: error, message: "", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == checkoutSuccessAlertView {
            if buttonIndex == 0 {
                
                self.dismissViewControllerAnimated(true, completion: nil)
                deletage?.didSettle()
                
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
