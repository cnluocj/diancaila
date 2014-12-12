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
    
    var mDetailTitleLabel: UILabel?
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, image: UIImage, title: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mImageView = UIImageView(image: image)
        mImageView?.frame = CGRectMake(15, 10, 24, 24)
        
        mTitleLabel = UILabel(frame: CGRectMake(50, 10, UIUtil.screenWidth - 50, 24))
        mTitleLabel?.text = title
        
        self.addSubview(mImageView!)
        self.addSubview(mTitleLabel!)
    }
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, image: UIImage, title: String, detailTitle: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mImageView = UIImageView(image: image)
        mImageView?.frame = CGRectMake(25, 15, 60, 60)
        self.addSubview(mImageView!)
        
        mTitleLabel = UILabel(frame: CGRectMake(110, 20, UIUtil.screenWidth - 90, 25))
        mTitleLabel?.text = title
        mTitleLabel?.font = UIFont.boldSystemFontOfSize(18)
        self.addSubview(mTitleLabel!)
        
        mDetailTitleLabel = UILabel(frame: CGRectMake(110, 50, UIUtil.screenWidth - 90, 20))
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
