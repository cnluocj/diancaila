//
//  DeskPickerViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/20.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

protocol OrderValuePassDelegate {
       func value(value: Any)  
}

class DeskPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: OrderValuePassDelegate!
    
    var picker :UIPickerView!
    
    var deskId: Int = 1
    
    var numOfDesk: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择桌子"
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
        
        let navitem = UINavigationItem(title: "选择桌子")
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressCancelButton:")
        let doneButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressDoneButton:")
        navitem.setLeftBarButtonItem(cancelButton, animated: false)
        navitem.setRightBarButtonItem(doneButton, animated: false)
        
        navBar.pushNavigationItem(navitem, animated: false)
        
        self.view.addSubview(navBar)
        
        self.picker = UIPickerView(frame: CGRectMake(0, 120, UIUtil.screenWidth, 150))
        self.picker.backgroundColor = UIColor.whiteColor()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.view.addSubview(picker)
    }
    
    func didPressCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didPressDoneButton(sender: UIBarButtonItem) {
        self.delegate.value(deskId)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // about picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numOfDesk
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "第\(row+1)桌"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        deskId = row+1
        
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
