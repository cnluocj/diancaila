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
        return UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1)
    }
    
    class var yellow_light: UIColor{
        return UIColor(red: 0.99607, green: 0.97647, blue: 0.63137, alpha: 1)
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
    
    
}
