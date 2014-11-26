//
//  Menu.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/16.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

class Menu{
    let id: String = ""
    let name: String = ""
    let description: String = ""
    let cover: String = ""
    let price: Double = 0
    let vipPrice: Double = 0
    let typeId: String = ""
    let shopId: String = ""
    let pubDate: String = ""
    
    init(id: String, name: String, description: String, cover: String, price: Double, vipPrice: Double, typeId: String, shopId: String, pubDate: String) {
        self.id = id
        self.name = name
        self.description = description
        self.cover = cover
        self.price = price
        self.vipPrice = vipPrice
        self.typeId = typeId
        self.shopId = shopId
        self.pubDate = pubDate
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
    }
}