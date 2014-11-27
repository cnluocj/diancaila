//
//  CustomActionSheet.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/27.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

protocol ActionSheetDeletage {
    func didPressDoneButton()
}

class CustomActionSheet: UIView {
    var contentView: UIView!
    var customView: UIView!
    var doneButton: UIButton!
    
    var deletage: ActionSheetDeletage?
    
    init(customView: UIView) {
        super.init(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
        
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0
        
        self.customView = customView
        
        self.contentView = UIView(frame: CGRectMake(0, UIUtil.screenHeight - 65 - self.customView.frame.height, UIUtil.screenWidth, 65 + self.customView.frame.height))
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(self.customView)
        
        // 确定按钮
        doneButton = UIButton(frame: CGRectMake(20, self.customView.frame.height + 6, UIUtil.screenWidth - 40, 44))
        doneButton.setTitle("确定", forState: UIControlState.Normal)
        doneButton.setBackgroundImage(UIUtil.imageFromColor(doneButton.frame.width, height: doneButton.frame.height, color: UIColor.orangeColor()), forState: UIControlState.Normal)
        doneButton.setBackgroundImage(UIUtil.imageFromColor(doneButton.frame.width, height: doneButton.frame.height, color: UIColor.grayColor()), forState: UIControlState.Selected)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: "didPressDoneButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(doneButton)
        
        
        // 点击空白部分可以dismiss 这个弹框
        let btn = UIButton(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - 50 - self.customView.frame.height))
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action: "hide:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didPressDoneButton(sender: UIView) {
        self.deletage?.didPressDoneButton()
        hide(sender)
    }
    
    func didPressShow(sender: UIView) {
       show()
    }
    
    
    func show() {
        self.userInteractionEnabled = true
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0.6
            self.contentView.alpha = 1
            }) { (isFinished: Bool) -> Void in
        }
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        UIApplication.sharedApplication().keyWindow?.addSubview(self.contentView)
    }
    
    func hide(sender: UIView) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0
            self.contentView.alpha = 0
            
            }) { (isFinished: Bool) -> Void in
                
            self.userInteractionEnabled = false
            
            self.removeFromSuperview()
            self.contentView.removeFromSuperview()
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
