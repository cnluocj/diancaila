//
//  Order.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/17.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

class Order: NSObject {
    
    var menuTypeIndex: Int = 0
    var menuIndex: Int = 0
    var menu: Menu = Menu()
    var count: Int = 0
    var deskId: Int = 0
    var state: Int = 0
    
    
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
    
    init(menu: Menu, deskId: Int) {
        self.menu = menu
        self.deskId = deskId
    }
}