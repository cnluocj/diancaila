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
    
<<<<<<< HEAD
    optional func didReceiveWaitMenu(result: NSDictionary)
    
=======
>>>>>>> parent of 5a8c213... before rename
    optional func didReceiveOrderId(result: NSDictionary)
}

class HttpController: NSObject {
    var deletage: HttpProtocol?
    
    class var path: String {
        return "http://114.215.105.93/"
    }
    
    class var menuTypeAPI: String {
        return path + "welcome/typeapi"
    }
    
    class var menuAPI: String {
        return path + "welcome/dishapi?id="
    }
    
    class var submitOrderAPI: String {
//        return path + "order/add_or?order="
        return "http://114.215.105.93/order/add_or"
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
    
    func submitOrder(url: String, json: String) {
        var nsUrl: NSURL! = NSURL(string: url)
        var request = NSMutableURLRequest(URL: nsUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (
            response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(string)
            let tempData = string?.dataUsingEncoding(NSUTF8StringEncoding)
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: NSErrorPointer()) as NSDictionary
                self.deletage?.didReceiveOrderId!(jsonResult)
            }
        }
    }
}