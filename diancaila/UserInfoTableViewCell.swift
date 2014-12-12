//
//  UserInfoTableViewCell.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    var mImageView: UIImageView?
    
    var mTitleLabel: UILabel?
    
    var mDetailTitleLabel: UILabel?
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, image: UIImage, title: String, detailTitle: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mImageView = UIImageView(image: image)
        mImageView?.frame = CGRectMake(15, 15, 60, 60)
        mImageView?.layer.borderWidth = 1
        mImageView?.layer.borderColor = UIUtil.gray.CGColor
        mImageView?.layer.cornerRadius = 5
        self.addSubview(mImageView!)
        
        mTitleLabel = UILabel(frame: CGRectMake(90, 20, UIUtil.screenWidth - 90, 25))
        mTitleLabel?.text = title
        mTitleLabel?.font = UIFont.boldSystemFontOfSize(18)
        self.addSubview(mTitleLabel!)
        
        mDetailTitleLabel = UILabel(frame: CGRectMake(90, 50, UIUtil.screenWidth - 90, 20))
        mDetailTitleLabel?.text = detailTitle
        mDetailTitleLabel?.font = UIFont.boldSystemFontOfSize(15)
        self.addSubview(mDetailTitleLabel!)
        
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
