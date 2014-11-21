//
//  DeskIdDelegate.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/20.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import Foundation

// 用于传递 桌子编号
protocol DeskIdDelegate {
    func passValue(id: Int)
}