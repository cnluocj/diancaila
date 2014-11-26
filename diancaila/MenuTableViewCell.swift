//
//  MenuTableViewCell.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/15.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    var menuLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        menuLabel = UILabel(frame: CGRectMake(15, 0, UIUtil.screenWidth/3-20, 50))
        // 自动换行
        menuLabel.numberOfLines = 0
        //        menuLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(menuLabel)
        
        self.backgroundColor = UIUtil.gray
        
        let view = UIView(frame: self.frame)
        view.backgroundColor = UIColor.whiteColor()
        let selectDivide = UIView(frame: CGRectMake(0, 0, 5, self.frame.height+6.5))
        selectDivide.backgroundColor = UIColor.orangeColor()
        view.addSubview(selectDivide)
        self.selectedBackgroundView = view
    }
    
    func setText(menuText: String) {
        self.menuLabel.text = menuText
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
