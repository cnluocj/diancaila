//
//  Order.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/17.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

class Order {
    
    var menuTypeIndex: Int = 0
    var menuIndex: Int = 0
    var menu: Menu = Menu(id: "", name: "", description: "", cover: "", price: 0, vipPrice: 0, typeId: "", shopId: "", pubDate: "")
    var count: Int = 0
    
    init(menuTypeIndex: Int, menuIndex: Int, menu: Menu, count: Int) {
        self.menuTypeIndex = menuTypeIndex
        self.menuIndex = menuIndex
        self.menu = menu
        self.count = count
    }
}