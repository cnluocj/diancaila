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
    
    optional func didFinishParseOrderId(orderId: String)
    
    optional func didFinishParseWaitMenu(menuArray: NSMutableArray)
    
    optional func didFinishParseDidNotPayOrder(notPayOrders: NSMutableArray)
    
    optional func didFinishParseDidPayOrder(payOrders: NSMutableArray)
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
//            let cover: String = menu.objectForKey("dish_cover") as String
            let cover = ""
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
    
    func parseWaitMenu(result: NSDictionary) {
        let resultArray: NSArray = result["wait"] as NSArray
        
        
        var menuArray: NSMutableArray = NSMutableArray()
        
        for menu in resultArray {
            //"id":"1","dish_id":"1","tab_id":"1","dish_name":"肉龙"
            let id = menu.objectForKey("id") as String
            let menuId = menu.objectForKey("dish_id") as String
            let menuName = menu.objectForKey("dish_name") as String
            let deskId = (menu.objectForKey("tab_id") as NSString).integerValue
            
            let menu = Menu(id: menuId, name: menuName)
            let order = Order()
            order.id = id
            order.menu = menu
            order.deskId = deskId
            
            menuArray.addObject(order)
        }
        
        
        parseDelegate?.didFinishParseWaitMenu!(menuArray)
    }
    
    
    func parseDidNotPayOrder(result: NSDictionary) {
        
        let resultArray: NSArray = result["wait_orders"] as NSArray
        var notPayOrder: NSMutableArray = NSMutableArray()
        
        
        for order in resultArray {
            let id =  order.objectForKey("ord_id") as String
            let deskId =  (order.objectForKey("tab_id") as NSString).integerValue
            let time = order.objectForKey("ord_time") as String
            let price = (order.objectForKey("price") as NSString).doubleValue
            let vipPrice = (order.objectForKey("vip_price") as NSString).doubleValue
            
            let norder = DOrder(id: id, deskId: deskId, orderTime: time, price: price, vipPrice: vipPrice)
            
            notPayOrder.addObject(norder)
        }
        
        parseDelegate?.didFinishParseDidNotPayOrder!(notPayOrder)
    }
    
    func parseDidPayOrder(result: NSDictionary) {
        //{"pay_orders":[{"ord_id":"1-2-20141205122208-10535","tab_id":"2","end_time":"2014-12-05 12:22:08","earn":"500"},{"ord_id":"1-8-20141205123333-3408","tab_id":"8","end_time":"2014-12-05 12:33:33","earn":"200"},{"ord_id":"1-18-20141205132625-8522","tab_id":"18","end_time":"2014-12-05 13:26:25","earn":"400"}]}
        
        let resultArray: NSArray = result["pay_orders"] as NSArray
        var notPayOrder: NSMutableArray = NSMutableArray()
        
        for order in resultArray {
            let id =  order.objectForKey("ord_id") as String
            let deskId =  (order.objectForKey("tab_id") as NSString).integerValue
            let time = order.objectForKey("end_time") as String
            let price = (order.objectForKey("earn") as NSString).doubleValue
            
            let norder = DOrder(id: id, deskId: deskId, orderTime: time, truePrice: price)
            
            notPayOrder.addObject(norder)
        }
        
        parseDelegate?.didFinishParseDidPayOrder!(notPayOrder)
    }
    
    
    // 由于麻烦，不转成本地的数据结构了，直接用dic了
    func parseOrderDetail(result: NSDictionary) {
        //{"order":{"order_id":"1-1-20141203165755-6910","list":[{"dish_id":"9","dish_name":"肉龙","num":"1","totalprice":"28"},{"dish_id":"10","dish_name":"三不馆er招牌香香骨（小）","num":"1","totalprice":"68"},{"dish_id":"11","dish_name":"三不馆er招牌香香骨（中）","num":"1","totalprice":"102"}]}}
        
//        let orderDetail = result["order"] as NSDictionary
//        let orderId = orderDetail["order_id"] as String
//        
//        let orderList = orderDetail["list"] as NSArray
//        let orderArray = [Order]()
//        for order in orderList {
//            orderList[dish_id]
//        }
    }
    
}