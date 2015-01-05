//
//  HttpController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/21.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation
import UIKit

@objc protocol HttpProtocol {
    
    optional func httpControllerDidReceiveResult(result: NSDictionary, forIdentifier identifier: String)
    
}

class HttpController: NSObject {
    var deletage: HttpProtocol?
    
    class var formalPath: String {
//return "http://114.215.105.93/"
return "http://dclweixin.diancai.la"
    }
    
    class var testPath: String {
        return "http://114.215.105.93"
    }
    
    class func pathArray() -> [String] {
        return [testPath, formalPath] // 顺序固定不变
    }
    
    class func pathTitles() -> [String] {
        return ["测试服务器", "正式服务器"]
    }
    
    class func path() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        let path = defaults.objectForKey("server") as? String
        if path == nil {
            defaults.setObject(pathArray()[0], forKey: "server")
            return pathArray()[0]
        }
        return path!
    }
    
    // get ------------------------------
    class func apiMenuType(shopId: String) -> String {
        return path() + "/welcome/typeapi?clerk_shop_id=\(shopId)"
    }
    
    class func apiMenu(typeId:String, shopId: String) -> String {
        return path() + "/welcome/dishapi?id=\(typeId)&clerk_shop_id=\(shopId)"
    }
    
    class func apiWaitMenu(shopId: String) -> String {
        return path() + "/order/re_all_ios?clerk_shop_id=\(shopId)"
    }
    
    // stat 上菜 1 ，退菜 2
    class func apiChangeFoodState(#id: String, stat: Int) -> String {
        return path() + "/order/change_state?id=" + id + "&stat=" + "\(stat)"
    }
    
    class func apiChangeFoodState2(#id: String, stat: Int) -> String {
        return path() + "/order/change_states?id=" + id + "&stat=" + "\(stat)"
    }
    
    class func apiNotPayOrder(shopId: String) -> String {
        return path() + "/order/re_orders_ios?clerk_shop_id=\(shopId)"
    }
    
    class func apiDidPayOrder(shopId: String) -> String {
        return path() + "/order/re_payorders_ios?clerk_shop_id=\(shopId)"
    }
    
    class func apiOrderDetail(orderId: String) -> String {
        return path() + "/order/re_order_detail?oid=\(orderId)"
    }
    
    class func apiChangeTableId(orderId: String, tableId: Int) -> String {
        return path() + "/order/change_table_id?oid=\(orderId)&tableid=\(tableId)"
    }
    
    class func apiCancelOrder(orderId: String) -> String {
        return path() + "/order/cancel_order?oid=\(orderId)"
    }
    
    class func apiTodayCount(shop_id: String) -> String {
        return path() + "/order/today_count?clerk_shop_id=\(shop_id)"
    }
    
    // 获取支付方式
    class func apiCheckoutType(shopId: String) -> String {
        return path() + "/order/checkout_type?clerk_shop_id=\(shopId)"
    }
    
    class func apiMoneyList(shopId: String) -> String {
        return path() + "/recharge/return_charge_money?clerk_shop_id=\(shopId)"
    }
    
    // post -----------------------------
    class func apiLogin() -> String {
        return path() + "/user/login"
    }
    
    class func apiRegister() -> String {
        return path() + "/user/register"
    }
    
    class var apiSubmitOrder: String {
        return path() + "/order/add_or"
    }
    
    // --现金支付 order_id checkout_id earn
    class func apiCheckout() -> String {
        return path() + "/order/checkout_order"
    }
    
    class func apiAddFood() -> String {
        return path() + "/order/add_order_dish"
    }
    
    // value: phone
    class func apiUserInfo() -> String {
        return path() + "/recharge/return_info"
    }
    
    // id mid money action
    class func apiCharge() -> String {
        return path() + "/recharge/charge"
    }
    
    class func apiBecomeVip() -> String {
        return path() + "/recharge/to_be_vipmember"
    }
    
    // "clerk_shop_id"=>1,"id"=>3
    class func apiCheckInfo() -> String {
        return path() + "/recharge/return_checkout_info"
    }
    
    func postWithUrl(url: String, andJson json: NSDictionary, forIdentifier identifier: String) {
        
        var nsUrl: NSURL! = NSURL(string: url)
        var request = NSMutableURLRequest(URL: nsUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        var data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request.HTTPBody = data
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(string)
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                
                self.deletage?.httpControllerDidReceiveResult!(jsonResult, forIdentifier: identifier)
                
            }
        }
    }
    
    
    
    func postWithUrl(url: String, andJson json: NSDictionary, forIdentifier identifier: String, inView view: UIView!) {
        
        var isTimeout = false
        
        // 开始等待 动画
        let waitIndicator = UIUtil.waitIndicator()
        waitIndicator.startAnimating()
        view.addSubview(waitIndicator)
        view.userInteractionEnabled = false
        
        // 计时器
        var timer: NSTimer? = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "timerAction:", userInfo: ["wait": waitIndicator, "view": view], repeats: false)
        
        var nsUrl: NSURL! = NSURL(string: url)
        var request = NSMutableURLRequest(URL: nsUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        var data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request.HTTPBody = data
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            //            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            //            println(string)
            //            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            
            if error == nil {
                // 停止计时器
                timer?.invalidate()
                timer = nil
                
                // 结束等待动画
                waitIndicator.removeFromSuperview()
                view.userInteractionEnabled = true
                
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                
                self.deletage?.httpControllerDidReceiveResult!(jsonResult, forIdentifier: identifier)
                

            }
        }
    }
    
    func timerAction(sender: NSTimer) {
        let dic = sender.userInfo as [String: AnyObject]
        let waitIndicator = dic["wait"] as? UIActivityIndicatorView
        let view = dic["view"] as? UIView
        
        // 结束等待动画
        if waitIndicator != nil {
            waitIndicator!.stopAnimating()
            waitIndicator!.removeFromSuperview()
        }
        if view != nil {
            view!.userInteractionEnabled = true
        }
        
        // 弹出提示框
        let alert = UIAlertView(title: "网络连接出问题了 0.0", message: "", delegate: nil, cancelButtonTitle: "好吧我检查一下")
        alert.show()
    }
    
    
    func getWithUrl(url: String, forIndentifier identifier: String) {
        println(url)
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(string)
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                
                self.deletage?.httpControllerDidReceiveResult!(jsonResult, forIdentifier: identifier)
            }
        }
    }
    
    
    func getWithUrl(url: String, forIndentifier identifier: String, inView view: UIView) {
        println(url)
        
        var isTimeout = false
        
        // 开始等待 动画
        let waitIndicator = UIUtil.waitIndicator()
        waitIndicator.startAnimating()
        view.addSubview(waitIndicator)
        view.userInteractionEnabled = false
        
        // 计时器
        var timer: NSTimer? = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "timerAction:", userInfo: ["wait": waitIndicator, "view": view], repeats: false)
        
        
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
//                        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                        println(string)
//                        let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            
            if error == nil {
                // 停止计时器
                timer?.invalidate()
                timer = nil
                // 结束等待动画
                waitIndicator.removeFromSuperview()
                view.userInteractionEnabled = true
                
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                
                self.deletage?.httpControllerDidReceiveResult!(jsonResult, forIdentifier: identifier)
            }
        }
    }
}