//
//  CustomGrid.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class CustomGrid: UIButton {
    
    var mImageView: UIImageView?
    
    var mTitleLabel: UILabel?
    
    var mDetailTitleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image: UIImage, title: String) {
        self.init(frame: frame)
        
        let customViewWidth = self.frame.height/8*3
        let customVIewHeight = self.frame.height/2
        
        mImageView = UIImageView(image: image)
        mImageView!.frame = CGRectMake(0, 0, customViewWidth, customViewWidth)
        
        let titleHeight = self.frame.height/8
        mTitleLabel = UILabel(frame: CGRectMake(0, customViewWidth + 5, customViewWidth, titleHeight))
        mTitleLabel!.text = title
        mTitleLabel?.font = UIFont.boldSystemFontOfSize(15)
        mTitleLabel!.textAlignment = NSTextAlignment.Center
        
        
        // 把 imageview 和 title 之间的间隔计算进去，所以加5
        let customView = CustomView(frame: CGRectMake(0, 0, customViewWidth, customVIewHeight + 5), whenTouchBegan: didTouch, whenTouchEnd: didTouchUpInside)
        customView.userInteractionEnabled = true
        customView.addSubview(mImageView!)
        customView.addSubview(mTitleLabel!)
        let tap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        customView.addGestureRecognizer(tap)
        
        centerFrameForView(customView)
        
        self.addSubview(customView)
    }
    
    convenience init(frame: CGRect, image: UIImage, title: String, detailTitle: String) {
        self.init(frame: frame)
        
        let customViewWidth = self.frame.height/4
        let customVIewHeight = self.frame.height/2
        
        mImageView = UIImageView(image: image)
        mImageView!.frame = CGRectMake(0, 0, customViewWidth, customViewWidth)
        
        let titleHeight = self.frame.height/8
        mTitleLabel = UILabel(frame: CGRectMake(-10, customViewWidth + 7, customViewWidth + 20, titleHeight))
        mTitleLabel!.text = title
        mTitleLabel?.textColor = UIColor.grayColor()
        mTitleLabel?.font = UIFont.boldSystemFontOfSize(15)
        mTitleLabel!.textAlignment = NSTextAlignment.Center
        
        mDetailTitleLabel = UILabel(frame: CGRectMake(-10, self.frame.height/8*3 + 13, customViewWidth + 20, titleHeight))
        mDetailTitleLabel!.text = detailTitle
        mDetailTitleLabel?.textColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        mDetailTitleLabel?.font = UIFont.boldSystemFontOfSize(13)
        mDetailTitleLabel!.textAlignment = NSTextAlignment.Center
        
        
        let customView = CustomView(frame: CGRectMake(0, 0, customViewWidth, customVIewHeight + 13), whenTouchBegan: didTouch, whenTouchEnd: didTouchUpInside)
        customView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        customView.addGestureRecognizer(tap)
        
        customView.addSubview(mImageView!)
        customView.addSubview(mTitleLabel!)
        customView.addSubview(mDetailTitleLabel!)
        
        centerFrameForView(customView)
        
        self.addSubview(customView)
    }
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapGesture(sender: UIView) {
        self.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        self.highlighted = false
    }
    
    func didTouch() {
        self.highlighted = true
    }
    
    func didTouchUpInside() {
        self.highlighted = false
    }
    
    func centerFrameForView(view: UIView) {
       view.frame =  CGRectMake((self.frame.width - view.frame.width)/2, (self.frame.height - view.frame.height)/2, view.frame.width, view.frame.height)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func buttonImageFromColor(color: UIColor) -> UIImage{
        let rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context  = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

}
