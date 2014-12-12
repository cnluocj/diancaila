//
//  CustomScrollView.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        return true
    }
}
