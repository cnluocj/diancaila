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
    var menu: Menu = Menu()
    var count: Int = 0
    
    init(_menuTypeIndex: Int, _menuIndex: Int, _menu: Menu, _count: Int) {
        self.menuTypeIndex = _menuTypeIndex
        self.menuIndex = _menuIndex
        self.menu = _menu
        self.count = _count
    }
}