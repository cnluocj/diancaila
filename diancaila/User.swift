//
//  User.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/15.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

class User: NSObject {
    var id = ""
    var name = ""
    var auth = ""
    var balance = 0.0
    var backMoney = 0.0
    var shopId = ""
    var phoneNumber = ""
    
    init(id: String, name: String, auth: String, balance: Double, backMoney: Double, shopId: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.auth = auth
        self.balance = balance
        self.backMoney = backMoney
        self.shopId = shopId
        self.phoneNumber = phoneNumber
    }
}