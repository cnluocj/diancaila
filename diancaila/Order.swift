//
//  Order.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/17.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

// 单个菜品
class Order: NSObject {
    
    var menuTypeIndex: Int = 0
    var menuIndex: Int = 0
    var menu: Menu = Menu()
    var count: Int = 0
    var deskId: Int = 0
    var state: Int = 0
    var customerNum = 0
    
    var id: String = "" // 唯一表示, 无意义
    
    init(menuTypeIndex: Int, menuIndex: Int, menu: Menu, count: Int) {
        self.menuTypeIndex = menuTypeIndex
        self.menuIndex = menuIndex
        self.menu = menu
        self.count = count
    }
    
    convenience init(menuTypeIndex: Int,  menuIndex: Int, menu: Menu, deskId: Int) {
        self.init(menu: menu, deskId: deskId)
        self.menuIndex = menuIndex
        self.menuTypeIndex = menuTypeIndex
    }
    
    // 等待上的菜
    init(id: String, deskId: Int, menu: Menu) {
        super.init()
        self.id = id
        self.deskId = deskId
        self.menu = menu
    }
   
    
    init(menu: Menu, deskId: Int) {
        self.menu = menu
        self.deskId = deskId
    }
    
    override init() {
        super.init()
    }
}