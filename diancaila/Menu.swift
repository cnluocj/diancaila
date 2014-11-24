//
//  Menu.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/16.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

struct Menu{
    let id: String = ""
    let name: String = ""
    let description: String = ""
    let cover: String = ""
    let price: Double = 0
    let vipPrice: Double = 0
    let type: MenuType = MenuType(id: "", name: "", pubDate: "")
    
    init(id: String, name: String, description: String, cover: String, price: Double, vipPrice: Double, type: MenuType) {
        self.id = id
        self.name = name
        self.description = description
        self.cover = cover
        self.price = price
        self.vipPrice = vipPrice
        self.type = type
    }
}