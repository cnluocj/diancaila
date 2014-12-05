//
//  HttpController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/21.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

@objc protocol HttpProtocol {
    optional func didReceiveMenuTypeResults(result: NSDictionary)
    
    optional func didReceiveMenuResults(result: NSDictionary)
    
    optional func didReceiveOrderId(result: NSDictionary)
    
    optional func didReceiveWaitMenu(result: NSDictionary)
    
    optional func didReceiveDidNotPayOrder(result: NSDictionary)
    
    optional func didReceiveDidPayOrder(result: NSDictionary)
    
    optional func didReceiveOrderDetail(result: NSMutableDictionary)
    
}

class HttpController: NSObject {
    var deletage: HttpProtocol?
    
    class var path: String {
//        return "http://114.215.105.93/"
        return "http://dclweixin.diancai.la/"
    }
    
    class var apiMenuType: String {
        return path + "welcome/typeapi"
    }
    
    class var apiMenu: String {
        return path + "welcome/dishapi?id="
    }
    
    class var apiSubmitOrder: String {
//        return path + "order/add_or?order="
        return path + "order/add_or"
    }
    
    class var apiWaitMenu: String {
        return path + "order/re_all_ios"
    }
    
    // stat 上菜 1 ，退菜 2
    class func apiOverOrder(#id: String, stat: Int) -> String {
        
        return path + "order/change_state?id=" + id + "&stat=" + "\(stat)"
    }
    
    class var apiNotPayOrder: String {
        return path + "order/re_orders_ios"
    }
    
    class func apiDidPayOrder() -> String {
        return path + "order/re_payorders_ios"
    }
    
    class var apiOrderDetail: String {
        return path + "order/re_order_detail?oid="
    }
    
    class func apiSettle(#orderId: String, price: Int) -> String {
        return path + "order/checkout_order?oid=" + orderId + "&earn=" + "\(price)"
    }
    
    class func apiAddFood() -> String {
        return path + "order/add_order_dish"
    }
    
    
    // todo 重构这个类
    func onSearch() {
        
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
    
    func onSearchMenu(url: String, typeId: String) {
        var nsUrl: NSURL! = NSURL(string: url + typeId)
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
//        println(json)
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
    
    // 发送 已上的菜 给服务器
    func overOrder(url: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request: NSURLRequest  = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println(string)
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
    
}