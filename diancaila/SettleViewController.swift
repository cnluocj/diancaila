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

class SettleViewController: UIViewController {
    
    var priceField: UITextField!
    
    var orderId: String!
    
    let httpController = HttpController()
    
    var deletage: SettleViewControllerDeletage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
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
        
        priceField = UITextField(frame: CGRectMake(10, 120, self.view.frame.width - 20, 40))
        priceField.borderStyle = UITextBorderStyle.RoundedRect
        priceField.placeholder = "输入实际金额"
        priceField.keyboardType = UIKeyboardType.NumberPad
        self.view.addSubview(priceField)
    }
    
    
    func didPressCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didPressDoneButton(sender: UIBarButtonItem) {
        
//        let numbers = NSString(string: "0123456789.")
        let price = NSString(string: priceField.text)
        
        if price == "" {
            let alert = UIAlertView(title: "", message: "金额不能为空", delegate: nil, cancelButtonTitle: "好的")
            alert.show()
            
        } else {
            
            httpController.settle(HttpController.apiSettle(orderId: orderId, price: price.integerValue))
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            deletage?.didSettle()
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
