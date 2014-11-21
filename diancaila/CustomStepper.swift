//
//  CustomStepper.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/19.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class CustomStepper: UIControl {
    
    var plusButton: UIButton!
    var minusButton: UIButton!
    
    var value: Double = 0.0 {
        didSet {
            if value > minValue {
                minusButton.hidden = false
            } else {
                minusButton.hidden = true
            }
        }
    }
    var step = 1.0
    var minValue = 0.0
    var maxValue = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        plusButton = UIButton(frame: CGRectMake(40, 0, 30, 30))
        plusButton.setBackgroundImage(UIImage(named: "plus"), forState: UIControlState.Normal)
        plusButton.addTarget(self, action: "didPressPlusButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(plusButton)
        
        minusButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        minusButton.setBackgroundImage(UIImage(named: "minus"), forState: UIControlState.Normal)
        minusButton.addTarget(self, action: "didPressMinusButton:", forControlEvents: UIControlEvents.TouchUpInside)
        minusButton.hidden = true
        self.addSubview(minusButton)
        
        
    }
    
    func test(sender: UIButton) {
        println("123")
    }
    
    func didPressPlusButton(sender: UIButton) {
        
        value = value + step
        if value > maxValue {
            value = maxValue
        }
        
        minusButton.hidden = false
        
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    func didPressMinusButton(sender: UIButton) {
        
        value = value - step
        if value < minValue {
            value = minValue
            
            minusButton.hidden = true
        }
        
       self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
