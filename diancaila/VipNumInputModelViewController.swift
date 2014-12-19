//
//  VipNumInputModelViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/19.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class VipNumInputModelViewController: UIViewController, UITextFieldDelegate {
    
    var navBar = UIUtil.navBar()
    
    var numtfView: UIView!
    
    let waitIndicator = UIUtil.waitIndicator()
    
    var textFieldArray = [UITextField]()
    let tfNum = 11
    let tfWidth = UIUtil.screenWidth / 11

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIUtil.gray_system
        
        self.title = "输入会员号码"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonDidPressed:")
        let navItem = UINavigationItem(title: "输入会员号码")
        navItem.leftBarButtonItem = cancelButton
        navBar.pushNavigationItem(navItem, animated: false)
        
        self.view.addSubview(navBar)
        
        numtfView = UIView(frame: CGRectMake(0, UIUtil.contentOffset, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset))
        
        for i in 0..<tfNum {
            var offset = CGFloat(i) * tfWidth
            var tf = UITextField(frame: CGRectMake(CGFloat(offset), 16, tfWidth, tfWidth))
            tf.keyboardType = UIKeyboardType.PhonePad
            tf.textAlignment = NSTextAlignment.Center
            tf.tintColor = UIColor.whiteColor()
            tf.layer.borderWidth = 1
            tf.layer.borderColor = UIUtil.gray.CGColor
            tf.backgroundColor = UIColor.whiteColor()
            tf.delegate = self
            textFieldArray.append(tf)
            
            numtfView.addSubview(tf)
        }
        
        self.view.addSubview(numtfView)
        
        textFieldArray[0].becomeFirstResponder()

    }
    
    func cancelButtonDidPressed(sender: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK : UITextFieldDelegate
    
    var index = 0
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if countElements(string) == 1 {
            if countElements(textField.text) == 1 {
                index++
                if index > tfNum - 1 {
                    index = tfNum - 1
                }
            }
            textFieldArray[index].becomeFirstResponder()
            if index == tfNum - 1 {
                textFieldArray[index].text = string
                
                waitIndicator.startAnimating()
                self.view.addSubview(waitIndicator)
                numtfView.userInteractionEnabled = false
                
                return false
            }
            return true
        } else {
            textField.text = ""
            index--
            if index < 0 {
                index = 0
            }
            textFieldArray[index].becomeFirstResponder()
            return false
        }
    }
    

}
