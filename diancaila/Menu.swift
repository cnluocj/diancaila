//
//  Menu.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/16.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

class Menu: NSObject {
    let id = ""
    let name = ""
    let desc = ""
    let cover = ""
    let price = 0.0
    let vipPrice = 0.0
    let typeId = ""
    let shopId = ""
    let pubDate = ""
    let isActivity = false
    
    // 在列表中的位置，搜索时候用
    var index = 0
    
    init(id: String, name: String, description: String, cover: String, price: Double, vipPrice: Double, typeId: String, shopId: String, pubDate: String, isActivity: Bool) {
        self.id = id
        self.name = name
        self.desc = description
        self.cover = cover
        self.price = price
        self.vipPrice = vipPrice
        self.typeId = typeId
        self.shopId = shopId
        self.pubDate = pubDate
        self.isActivity = isActivity
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    override init() {
        super.init()
    }
}