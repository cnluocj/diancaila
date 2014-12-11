//
//  CustomView.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/11.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    var whenTouchBegan: (()->())?
    var whenTouchEnd: (()->())?
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, whenTouchBegan: ()->(), whenTouchEnd: ()->()) {
        self.init(frame: frame)
        
        self.whenTouchEnd = whenTouchEnd
        self.whenTouchBegan = whenTouchBegan
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        whenTouchBegan!()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        whenTouchEnd!()
    }
    
    

}
