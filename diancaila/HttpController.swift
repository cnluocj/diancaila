//
//  HttpController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/21.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

@objc protocol HttpProtocol {
    
    optional func didReceiveResults(result: NSDictionary)
    
    optional func didReceiveMenuTypeResults(result: NSDictionary)
    
    optional func didReceiveMenuResults(result: NSDictionary)
    
    optional func didReceiveOrderId(result: NSDictionary)
    
    optional func didReceiveWaitMenu(result: NSDictionary)
    
    optional func didReceiveDidNotPayOrder(result: NSDictionary)
    
    optional func didReceiveDidPayOrder(result: NSDictionary)
    
    optional func didReceiveOrderDetail(result: NSMutableDictionary)
    
    optional func didReceiveChangeTableIdState(result: NSMutableDictionary)
    
    optional func didReceiveCancelOrderState(result: NSMutableDictionary)
    
    optional func didReceiveChangeFoodState(result: NSDictionary)
    
    optional func didReceiveUserInfo(result: NSDictionary)
    
    optional func didReceiveTodayCount(result: NSDictionary)
    
}

class HttpController: NSObject {
    var deletage: HttpProtocol?
    
    class var path: String {
return "http://114.215.105.93/"
//return "http://dclweixin.diancai.la/"
    }
    
    class func apiLogin() -> String {
        return path + "user/login"
    }
    
    class func apiRegister() -> String {
        return path + "user/register"
    }
    
    class func apiMenuType(shopId: String) -> String {
        return path + "welcome/typeapi?clerk_shop_id=\(shopId)"
    }
    
    
    class func apiMenu(typeId:String, shopId: String) -> String {
        return path + "welcome/dishapi?id=\(typeId)&clerk_shop_id=\(shopId)"
    }
    
    
    class var apiSubmitOrder: String {
//        return path + "order/add_or?order="
        return path + "order/add_or"
    }
    
//    class var apiWaitMenu: String {
//        return path + "order/re_all_ios"
//    }
    
    class func apiWaitMenu(shopId: String) -> String {
        return path + "order/re_all_ios?clerk_shop_id=\(shopId)"
    }
    
    // stat 上菜 1 ，退菜 2
    class func apiChangeFoodState(#id: String, stat: Int) -> String {
        
        return path + "order/change_state?id=" + id + "&stat=" + "\(stat)"
    }
    
//    class var apiNotPayOrder: String {
//        return path + "order/re_orders_ios"
//    }
    class func apiNotPayOrder(shopId: String) -> String {
        return path + "order/re_orders_ios?clerk_shop_id=\(shopId)"
    }
    
    class func apiDidPayOrder(shopId: String) -> String {
        return path + "order/re_payorders_ios?clerk_shop_id=\(shopId)"
    }
    
    class func apiOrderDetail() -> String {
        return path + "order/re_order_detail?oid="
    }
    
    class func apiSettle(#orderId: String, price: Int) -> String {
        return path + "order/checkout_order?oid=" + orderId + "&earn=" + "\(price)"
    }
    
    class func apiAddFood() -> String {
        return path + "order/add_order_dish"
    }
    
    class func apiChangeTableId(orderId: String, tableId: Int) -> String {
        return path + "order/change_table_id?oid=\(orderId)&tableid=\(tableId)"
    }
    
    
    class func apiCancelOrder(orderId: String) -> String {
        return path + "order/cancel_order?oid=\(orderId)"
    }
    
    // post方式  value: phone
    class func apiUserInfo() -> String {
        return path + "recharge/return_info"
    }
    
    // post value: id mid money action
    class func apiCharge() -> String {
        return path + "recharge/charge"
    }
    
    class func apiTodayCount() -> String {
        return path + "order/today_count"
    }
    
    // todo 重构这个类
    func onSearch() {
        
    }
    
    
    func post(url: String, json: NSDictionary) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request = NSMutableURLRequest(URL: nsUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
//        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding)
        var data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request.HTTPBody = data
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                        println(string)
//                        let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                
                self.deletage?.didReceiveResults!(jsonResult)
            }
        }
    }
    
    func onSearchTodayCount(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            //            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            //            println(string)
            //            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveTodayCount!(jsonResult)
            }
        }
    }
    
    
    func onSearchMenuType(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(string)
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveMenuTypeResults!(jsonResult)
            }
        }
    }
    
    func onSearchMenu(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                        println(string)
//                        let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveMenuResults!(jsonResult)
            }
        }
    }
    
    // 等待上的菜
    func onSearchWaitMenu(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("\(string)")
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveWaitMenu!(jsonResult)
            }
        }
    }
    
    
    func submitOrder(url: String, json: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request = NSMutableURLRequest(URL: nsUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(string)
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveOrderId!(jsonResult)
            }
        }
    }
    
    // 发送 已上的菜/退菜 给服务器
    func changeFoodState(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(string)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveChangeFoodState!(jsonResult)
            }
        }
    }
    
    func onSearchDidNotPayOrder(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                        println("\(string)")
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveDidNotPayOrder!(jsonResult)
            }
        }
 
    }
    
    func onSearchDidPayOrder(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                                    println("\(string)")
//                        let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveDidPayOrder!(jsonResult)
            }
        }
 
    }
    
    
    func onSearchOrderDetailById(id: String, url: String) {
        var nsUrl: NSURL! = NSURL(string: url + id)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                                    println("\(string)")
//                        let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSMutableDictionary
                self.deletage?.didReceiveOrderDetail!(jsonResult)
            }
        }
    }
    
    func settle(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//                        println(string)
        }
    }
    
    func changeTableId(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("\(string)")
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSMutableDictionary
                self.deletage?.didReceiveChangeTableIdState!(jsonResult)
            }
        }
    }
    
    func cancelOrder(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("\(string)")
//            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSMutableDictionary
                self.deletage?.didReceiveCancelOrderState!(jsonResult)
            }
        }
    }
    
}