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
}

class JSONController : NSObject {
    var menuTypeDelegate: JSONParseProtocol?
    
    func parseMenuType(result: NSDictionary) {
        let menuTypeArray: NSArray = result["menutype"] as NSArray
        var resultArray: NSMutableArray = NSMutableArray()
        
        for type in menuTypeArray {
            let typeId: String = type.objectForKey("d_type_id") as String
            let typeName: String = type.objectForKey("d_type_name") as String
            let pubDate: String = type.objectForKey("d_type_time") as String
            
            let menuType: MenuType = MenuType(id: typeId, name: typeName, pubDate: pubDate)
            resultArray.addObject(menuType)
        }
        
        menuTypeDelegate?.didFinishParseMenuTypeAndReturn!(resultArray)
    }
}