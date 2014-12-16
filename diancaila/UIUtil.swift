//
//  UIUtil.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class UIUtil {
    
    /** 颜色相关 */
    /* 导航栏颜色 */
    class var navColor: UIColor {
        return UIColor(red: 0.18431, green: 0.2, blue: 0.26666, alpha: 1)
    }
    class var navColorPressed: UIColor {
        return UIColor(red: 0.10196, green: 0.10688, blue: 0.11764, alpha: 0.95)
    }
    class var gray: UIColor{
        return UIColor(red: 0.92549, green: 0.92549, blue: 0.92549, alpha: 1)
    }
    
    class var gray_system : UIColor{
        return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1)
    }
    
    class var yellow_light: UIColor{
        return UIColor(red: 0.99607, green: 0.97647, blue: 0.63137, alpha: 1)
    }
    
    class func flatBlue() -> UIColor {
        return UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    }
    
    // 导航栏是否透明的偏移量
    class var contentOffset: CGFloat{
        return CGFloat(64)
    }
    
    /** 屏幕数值相关 */
    class var screenWidth: CGFloat  { return UIScreen.mainScreen().bounds.size.width }
    class var screenHeight: CGFloat { return UIScreen.mainScreen().bounds.size.height }
    class var statusHeight: CGFloat { return UIApplication.sharedApplication().statusBarFrame.height }
    
    /* 生成纯色的UIImage */
    class func imageFromColor(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage{
        let rect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(rect.size)
        let context  = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /* 改变UIImage的大小 */
    class func scaleToSize(img: UIImage, size: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size)
        img.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    
    class func imageFromView(view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func navController() ->UINavigationController{
        let navController = UINavigationController()
        //20为iphone状态栏高度
        let navImage = UIUtil.imageFromColor(UIUtil.screenWidth, height: navController.navigationBar.frame.height+20, color: UIUtil.navColor)
        // 改变背景颜色，使用生成的纯色图片
        navController.navigationBar.setBackgroundImage(navImage, forBarMetrics: UIBarMetrics.Default)
        // 主体是否从顶部开始/是否透明
        navController.navigationBar.translucent = false
        // 改变title颜色
        navController.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        // 改变导航栏上字体颜色，除了title
        navController.navigationBar.tintColor = UIColor.whiteColor()
        return navController
    }
    
    
    class func navBar() ->UINavigationBar{
        let navBar = UINavigationBar(frame: CGRectMake(0, 0, UIUtil.screenWidth, 64))
        //20为iphone状态栏高度
        let navImage = UIUtil.imageFromColor(UIUtil.screenWidth, height: 64, color: UIUtil.navColor)
        // 改变背景颜色，使用生成的纯色图片
        navBar.setBackgroundImage(navImage, forBarMetrics: UIBarMetrics.Default)
        // 主体是否从顶部开始/是否透明
        navBar.translucent = false
        // 改变title颜色
        navBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        // 改变导航栏上字体颜色，除了title
        navBar.tintColor = UIColor.whiteColor()
        return navBar
    }
    
    
    class func waitIndicator() -> UIActivityIndicatorView {
        let waitIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        waitIndicator.backgroundColor = UIColor.grayColor()
        waitIndicator.alpha = 0.8
        waitIndicator.frame.size = CGSize(width: 150, height: 150)
        waitIndicator.layer.cornerRadius = 5
        // 居中显示
        waitIndicator.layer.position = CGPoint(x: UIUtil.screenWidth/2, y: UIUtil.screenHeight/3)
        waitIndicator.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        return waitIndicator
    }
}
