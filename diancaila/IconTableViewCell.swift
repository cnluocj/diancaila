//
//  IconTableViewCell.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class IconTableViewCell: UITableViewCell {
    
    var mImageView: UIImageView?
    
    var mTitleLabel: UILabel?
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, image: UIImage, title: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mImageView = UIImageView(image: image)
        mImageView?.frame = CGRectMake(15, 10, 24, 24)
        
        mTitleLabel = UILabel(frame: CGRectMake(50, 10, UIUtil.screenWidth - 50, 24))
        mTitleLabel?.text = title
        
        self.addSubview(mImageView!)
        self.addSubview(mTitleLabel!)
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
