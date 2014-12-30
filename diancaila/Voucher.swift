//
//  Voucher.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/30.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

class Voucher: NSObject {
    var id = ""
    var name = ""
    var isOnline = true
    var realValue = 0.0
    var voucherValue = 0.0
    var shopId = ""
    var maxNum = 0
    
    var num = 0
    
    init(id: String, name: String, isOnline: Bool, realValue: Double, voucherValue: Double, shopId: String, maxNum: Int) {
        
        self.id = id
        self.isOnline = isOnline
        self.realValue = realValue
        self.voucherValue = voucherValue
        self.shopId = shopId
        self.name = name
        self.maxNum = maxNum
    }
    
}