//
//  JSONController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/11/24.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation


@objc protocol JSONParseProtocol {
    
    optional func didFinishParseMenuTypeAndReturn(menuTypeArray: NSArray)
    
    optional func didFinishParseMenuByTypeIdAndReturn(menuArray: NSArray)
    
<<<<<<< HEAD
    optional func didFinishParseWaitMenu(menuArray: NSMutableArray)
    
=======
>>>>>>> parent of 5a8c213... before rename
    optional func didFinishParseOrderId(orderId: String)
}

class JSONController : NSObject {
    var parseDelegate: JSONParseProtocol?
    
    func parseMenuType(result: NSDictionary) {
        let resultArray: NSArray = result["menutype"] as NSArray
        var menuTypeArray: NSMutableArray = NSMutableArray()
        
        for type in resultArray {
            let typeId: String = type.objectForKey("d_type_id") as String
            let typeName: String = type.objectForKey("d_type_name") as String
            let pubDate: String = type.objectForKey("d_type_time") as String
            
            let menuType: MenuType = MenuType(id: typeId, name: typeName, pubDate: pubDate)
            menuTypeArray.addObject(menuType)
        }
        
        parseDelegate?.didFinishParseMenuTypeAndReturn!(menuTypeArray)
    }
    
    
    func parseMenu(result: NSDictionary) {
        let resultArray: NSArray = result["dish"] as NSArray
        var menuArray: NSMutableArray = NSMutableArray()
        
        for menu in resultArray {
            let id: String = menu.objectForKey("dish_id") as String
            let name: String = menu.objectForKey("dish_name") as String
            let description: String = menu.objectForKey("dish_des") as String
            let typeId: String = menu.objectForKey("dish_type_id") as String
            let cover: String = menu.objectForKey("dish_cover") as String
            let price: Double = (menu.objectForKey("dish_origin_price") as NSString).doubleValue
            let vipPrice: Double = (menu.objectForKey("dish_user_price") as NSString).doubleValue
            let shopId: String = menu.objectForKey("dish_shop_id") as NSString
            let pubDate: String = menu.objectForKey("dish_time") as NSString
            
            let menu: Menu = Menu(id: id, name: name, description: description, cover: cover, price: price, vipPrice: vipPrice, typeId: typeId, shopId: shopId, pubDate: pubDate)
            menuArray.addObject(menu)
        }
        
        parseDelegate?.didFinishParseMenuByTypeIdAndReturn!(menuArray)
    }
    
    func parseOrderId(result: NSDictionary) {
        let orderId = result["order_id"] as String
        
        
        parseDelegate?.didFinishParseOrderId!(orderId)
    }
    
    
}