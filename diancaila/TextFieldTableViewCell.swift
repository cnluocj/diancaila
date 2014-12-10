//
//  TextFieldTableViewCell.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/10.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    var textField: UITextField!
    
    var titleLabel: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: CGRectMake(20, 0, 60, self.frame.height))
        titleLabel.textAlignment = NSTextAlignment.Right
        self.addSubview(titleLabel)
        
        textField = UITextField(frame: CGRectMake(90, 0, self.frame.width - 90, self.frame.height))
        self.addSubview(textField)
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
