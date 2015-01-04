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
    
    
    var menuStyleIndex: Int!
    var menuIndex: Int!
    var menu: Menu!
    var viewcontroller: OrderViewController!
    var superTableView: UITableView!
    
    var foodImage: UIImageView?
    var tempImage: UIImageView?
    var board: UIView?
    var imageTapGesture: UITapGestureRecognizer!
    var isFoodImageLarge = false
    
    var foodNameLabel: UILabel?
    var foodDescTextView: UITextView?
    var textView: UIView?
    
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
        
        
        if menu.isActivity {
            let activityLabel = UILabel(frame: CGRectMake(0, 0, superTableView.frame.width, viewcontroller.menuDetailCellHeight))
            activityLabel.text = "活动中"
            activityLabel.backgroundColor = UIUtil.gray_system
            activityLabel.textColor = UIColor.whiteColor()
            activityLabel.font = UIFont.boldSystemFontOfSize(50)
            activityLabel.textAlignment = NSTextAlignment.Center
            self.contentView.addSubview(activityLabel)
        }
        
        
        foodImage = UIImageView(image: UIImage(named: "no_picture"))
        foodImage!.frame = CGRectMake(15, 10, 50, 50)
        foodImage!.layer.borderWidth = 1
        foodImage!.layer.borderColor = UIColor.lightGrayColor().CGColor
        foodImage!.userInteractionEnabled = true
        imageTapGesture = UITapGestureRecognizer(target: self, action: "imageTapGesture:")
        foodImage!.addGestureRecognizer(imageTapGesture)
        self.contentView.addSubview(foodImage!)
        
        // 异步加载图片
        if menu.cover != "" {
            let url  = NSURL(string: HttpController.path() + menu.cover)
            let request = NSURLRequest(URL: url!)
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(
                request, queue: queue, completionHandler: { (response, data, error) -> Void in
                let image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.foodImage!.image = image
                    })
            })
        }
        
        
        
        nameLabel = UILabel(frame: CGRectMake(75, 0, UIUtil.screenWidth/7*5-20, 50))
        nameLabel.numberOfLines = 0
        self.contentView.addSubview(nameLabel)
        
        priceLabel = UILabel(frame: CGRectMake(15, 65, 100, 20))
        priceLabel.textColor = UIColor.orangeColor()
        self.contentView.addSubview(priceLabel)
        
        // 如果大于300，就是弹出 点菜清单 的 界面
        if (self.superTableView.frame.width > 300) {
            self.steper = CustomStepper(frame: CGRectMake(self.superTableView.frame.width/7*5, 50, self.superTableView.frame.width/3, 50))
            self.badge = UIButton(frame: CGRectMake(UIUtil.screenWidth - 50, 10, 25, 25))
            
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
    
    
    func imageTapGesture(gesture: UITapGestureRecognizer) {
        
        let rectInTableView = superTableView.rectForRowAtIndexPath(NSIndexPath(forRow: menuIndex, inSection: 0))
        var x = rectInTableView.origin.x
        var y = rectInTableView.origin.y
        let imageRectInTableView = CGRectMake(x + 15, y + 10 + 44, 50, 50)
        let rectInSuperView = superTableView.convertRect(imageRectInTableView, toView: viewcontroller.view)
        
        if !isFoodImageLarge {
            let imageHeight = UIUtil.screenWidth
            
            board = UIView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight))
            board?.alpha = 0
            board?.backgroundColor = UIColor.whiteColor()
            UIApplication.sharedApplication().keyWindow?.addSubview(board!)
            
            textView = UIView(frame: CGRectMake(0, imageHeight, UIUtil.screenWidth, UIUtil.screenHeight - imageHeight))
            textView?.alpha = 0
            UIApplication.sharedApplication().keyWindow?.addSubview(textView!)
            
            foodNameLabel = UILabel(frame: CGRectMake(15, 10, UIUtil.screenWidth - 30, 50))
            foodNameLabel?.font = UIFont.boldSystemFontOfSize(24)
            foodNameLabel?.text = menu.name
            textView?.addSubview(foodNameLabel!)
            

            foodDescTextView = UITextView(frame: CGRectMake(10, 60, UIUtil.screenWidth - 20, UIUtil.screenHeight - imageHeight - 50))
            foodDescTextView?.editable = false
            foodDescTextView?.font = UIFont.systemFontOfSize(15)
            foodDescTextView?.text = menu.desc
            foodDescTextView?.text = "习近平指出，办好中国特色社会主义大学，要坚持立德树人，把培育和践行社会主义核心价值观融入教书育人全过程；强化思想引领，牢牢把握高校意识形态工作领导权；坚持和完善党委领导下的校长负责制，不断改革和完善高校体制机制；全面推进党的建设各项工作，有效发挥基层党组织战斗堡垒作用和共产党员先锋模范作用。各级党委和宣传思想部门、组织部门、教育部门要加强对高校党的建设工作的领导和指导，坚持党的教育方针，坚持社会主义办学方向，加强和改进思想政治工作，切实把党要管党、从严治党落到实处。"
            textView?.addSubview(foodDescTextView!)
            
            
            tempImage = UIImageView(image: foodImage?.image)
            tempImage!.frame = rectInSuperView
            tempImage?.userInteractionEnabled = true
            tempImage?.addGestureRecognizer(imageTapGesture)
            UIApplication.sharedApplication().keyWindow?.addSubview(tempImage!)

            
            foodImage?.alpha = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
                
                self.tempImage!.frame = CGRectMake(0, 0, UIUtil.screenWidth, imageHeight)
                
                
                }) { (finished: Bool) -> Void in
                    
                    
                self.isFoodImageLarge = true
            }
            
            UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                self.board!.alpha = 1
                self.textView?.alpha = 1
                }, completion: { (finished: Bool) -> Void in
            })
            
            
        } else {
            
            self.board?.alpha = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
                
                let rectInWindow = CGRectMake(rectInSuperView.origin.x, rectInSuperView.origin.y + UIUtil.contentOffset - 44, rectInSuperView.width, rectInSuperView.height)
                
                self.tempImage!.frame = rectInWindow
                self.textView?.alpha = 0
                
                }, completion: { (finished: Bool) -> Void in
                    self.foodImage?.alpha = 1
                    
                    self.isFoodImageLarge = false
                    self.tempImage?.removeFromSuperview()
                    self.board?.removeFromSuperview()
                    self.textView?.removeFromSuperview()
                    
                    self.foodImage?.userInteractionEnabled = true
                    self.imageTapGesture = UITapGestureRecognizer(target: self, action: "imageTapGesture:")
                    self.foodImage!.addGestureRecognizer(self.imageTapGesture)
            })
        }
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
            
            let order = Order(menuTypeIndex: self.menuStyleIndex, menuIndex: self.menuIndex, menu: menu, count: Int(sender.value))
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
