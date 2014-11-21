//
//  MenuDetailTableViewCell.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/15.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class MenuDetailTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var steper: CustomStepper!
    var badge: UIButton!
    
    // badge变化前的数
    var preNum = 0.0
    
    let context = UIGraphicsGetCurrentContext()
    let PI = CGFloat(3.1415926)
    
    var menuStyleIndex: Int!
    var menuIndex: Int!
    var menu: Menu!
    var viewcontroller: OrderViewController!
    var superTableView: UITableView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, _menuStyleIndex: Int, _menuIndex: Int, _menu: Menu, _viewContriller: OrderViewController, _superTableView: UITableView) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewcontroller = _viewContriller
        menuIndex = _menuIndex
        menu = _menu
        menuStyleIndex = _menuStyleIndex
        superTableView = _superTableView
        
        
        
        nameLabel = UILabel(frame: CGRectMake(15, 0, UIUtil.screenWidth/3*2-20, 50))
        self.contentView.addSubview(nameLabel)
        
        priceLabel = UILabel(frame: CGRectMake(15, 40, 100, 50))
        priceLabel.textColor = UIColor.orangeColor()
        self.contentView.addSubview(priceLabel)
        
        // 如果大于300，就是弹出的全部菜单
        if (self.superTableView.frame.width > 300) {
            self.steper = CustomStepper(frame: CGRectMake(self.superTableView.frame.width/7*5, 50, self.superTableView.frame.width/3, 50))
            self.badge = UIButton(frame: CGRectMake(UIUtil.screenWidth - 35, 10, 25, 25))
            
        } else {
            
            self.badge = UIButton(frame: CGRectMake(UIUtil.screenWidth/3*2-35, 10, 25, 25))
            self.steper = CustomStepper(frame: CGRectMake(self.superTableView.frame.width/3*2-15, 50, self.superTableView.frame.width/3, 50))
        }
        self.steper.addTarget(self, action: "valueChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.contentView.addSubview(steper)
        
        badge.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        badge.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        badge.setBackgroundImage(UIImage(named: "badge"), forState: UIControlState.Normal)
        badge.setTitle("", forState: UIControlState.Normal)
        badge.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        badge.hidden = true
        self.contentView.addSubview(badge)
    }
    
    func set(name: String, price: Double) {
        nameLabel.text = name
        priceLabel.text = "￥\(price)"
    }
    
    func valueChange(sender: UIStepper) {
        
        if sender.value == 0 {
            
            badge.hidden = true
            
            self.viewcontroller.orderList.removeValueForKey("\(menuStyleIndex)_\(menuIndex)")
            
            if self.superTableView == self.viewcontroller.orderListTableView {
                self.superTableView.reloadData()
            }
            
        } else {
            
            badge.hidden = false
            badge.setTitle("\(Int(sender.value))", forState: UIControlState.Normal)
            
            let order = Order(_menuTypeIndex: self.menuStyleIndex, _menuIndex: self.menuIndex, _menu: menu, _count: Int(sender.value))
            self.viewcontroller.orderList["\(self.menuStyleIndex)_\(menuIndex)"] = order
        }
        
        
        var count = self.viewcontroller.orderCount
        var price = self.viewcontroller.orderPrice
        if preNum < sender.value {
            count = count + 1
            price = price + menu.price
        } else if preNum > sender.value {
            count = count - 1
            price = price - menu.price
        } else if preNum > sender.value {
        }
        // 值传递，得把结果传回去
        self.viewcontroller.orderCount = count
        self.viewcontroller.orderPrice = price
        
        if count == 0 {
            self.viewcontroller.badge.hidden = true
            self.viewcontroller.chooseOverButton.enabled = false
        } else {
            self.viewcontroller.badge.hidden = false
            self.viewcontroller.chooseOverButton.enabled = true
        }
        
        self.viewcontroller.badge.setTitle("\(count)", forState: UIControlState.Normal)
        self.viewcontroller.priceLabel.text = "￥\(price)"
        preNum = sender.value
    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
