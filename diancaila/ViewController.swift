//
//  ViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate {
    
    /* 点餐按钮 */
    var orderBtn: CustomGrid!
    
    /* 外卖按钮 */
    var takeawayBtn: CustomGrid!
    
    
    var balanceButton: CustomGrid!
    var backMoneyButton: CustomGrid!
    
    
    /* 导航栏高度 */
    var navHeight: CGFloat!
    
    /* 屏幕顶部到内容的距离 */
    var topMargin: CGFloat!
    
    /* 大方块的字体大小 */
    let HEAD_BTN_FONT_SIZE = CGFloat(20)
    
    /* 大方块高度 */
//    let headButtonHeight = CGFloat(120)
    let headButtonHeight = UIUtil.screenHeight/5
    
    var isNextLevel = false // 半段是否跳转到下一层，如果是，把title改为空
    
    var user: User!
    
    var isFirstLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "点菜啦"
        self.view.backgroundColor = UIUtil.gray_system
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // 设置状态栏字体颜色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // 导航栏高度，如果没有导航栏，高度为0
        navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        topMargin = navHeight + UIUtil.statusHeight
        
        // bar
//        let orderBarItem = UIBarButtonItem(title: "订单", style: UIBarButtonItemStyle.Plain, target: self, action: "didPressOrderBarItem:")
//        orderBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
//        self.navigationItem.rightBarButtonItem = orderBarItem
        
        
        let bgimg = UIUtil.imageFromColor(UIUtil.screenWidth/2, height: headButtonHeight, color: UIUtil.navColor)
        let bgimgSelected = UIUtil.imageFromColor(UIUtil.screenWidth/2, height: headButtonHeight, color: UIUtil.navColorPressed)
        // 点餐按钮
        orderBtn = CustomGrid(frame: CGRectMake(0, 0, UIUtil.screenWidth/2 + 1, headButtonHeight), image: UIImage(named: "order")!, title: "点餐")
        orderBtn.addTarget(self, action: "didPressOrderButton:", forControlEvents: UIControlEvents.TouchUpInside)
        orderBtn.setBackgroundImage(bgimg, forState: UIControlState.Normal)
        orderBtn.setBackgroundImage(bgimgSelected, forState: UIControlState.Highlighted)
        orderBtn.mTitleLabel?.textColor = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
        self.view.addSubview(orderBtn)
        
        
        // 外卖按钮 （暂做 订单 按钮）
        takeawayBtn = CustomGrid(frame: CGRectMake(UIUtil.screenWidth/2, 0, UIUtil.screenWidth/2, headButtonHeight), image: UIImage(named: "list")!, title: "订单")
        takeawayBtn.addTarget(self, action: "didPressOrderBarItem:", forControlEvents: UIControlEvents.TouchUpInside)
        takeawayBtn.setBackgroundImage(bgimg, forState: UIControlState.Normal)
        takeawayBtn.setBackgroundImage(bgimgSelected, forState: UIControlState.Highlighted)
        takeawayBtn.mTitleLabel?.textColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
        self.view.addSubview(orderBtn)
        self.view.addSubview(takeawayBtn)
        
        
        let scrollView = CustomScrollView(frame: CGRectMake(0, headButtonHeight, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset - headButtonHeight))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: UIUtil.screenWidth, height: UIUtil.screenHeight - UIUtil.contentOffset - headButtonHeight+1)
        scrollView.scrollEnabled = true
        scrollView.bounces = true
        scrollView.delaysContentTouches = false // 解决里面的按钮点击迟缓bug
        self.view.addSubview(scrollView)
        
        
        let smailBgimg = UIImage(named: "app_item_bg")
        let smailBgimgSelected = UIImage(named: "app_item_pressed_bg")
        let smailBgimg1 = UIUtil.imageFromColor(UIUtil.screenWidth/3, height: 130, color: UIColor.whiteColor())
        let smailBgimgSelected1 = UIUtil.imageFromColor(UIUtil.screenWidth/3, height: 130, color: UIUtil.gray_system)
        
        balanceButton = CustomGrid(frame: CGRectMake(0, 0, UIUtil.screenWidth/3 - 0.8, 130 - 0.8), image: UIImage(named: "money")!, title: "余额", detailTitle: "￥?")
        balanceButton.addTarget(self, action: "didPressOrderButton:", forControlEvents: UIControlEvents.TouchUpInside)
        balanceButton.setBackgroundImage(smailBgimg1, forState: UIControlState.Normal)
        balanceButton.setBackgroundImage(smailBgimgSelected1, forState: UIControlState.Highlighted)
        scrollView.addSubview(balanceButton)
        
        backMoneyButton = CustomGrid(frame: CGRectMake(UIUtil.screenWidth/3, 0, UIUtil.screenWidth/3 - 0.8, 130 - 0.8), image: UIImage(named: "moneybox")!, title: "返现", detailTitle: "￥?")
        backMoneyButton.setBackgroundImage(smailBgimg1, forState: UIControlState.Normal)
        backMoneyButton.setBackgroundImage(smailBgimgSelected1, forState: UIControlState.Highlighted)
        scrollView.addSubview(backMoneyButton)
        
        let couponButton = CustomGrid(frame: CGRectMake(UIUtil.screenWidth/3*2, 0, UIUtil.screenWidth/3, 130 - 0.8), image: UIImage(named: "ticket")!, title: "优惠券", detailTitle: "30张")
        couponButton.setBackgroundImage(smailBgimg1, forState: UIControlState.Normal)
        couponButton.setBackgroundImage(smailBgimgSelected1, forState: UIControlState.Highlighted)
        scrollView.addSubview(couponButton)
        
        let vipCardButton = CustomGrid(frame: CGRectMake(0, 0 + 130, UIUtil.screenWidth/3 - 0.8, 130 - 0.8), image: UIImage(named: "vip")!, title: "会员卡", detailTitle: "30张")
        vipCardButton.setBackgroundImage(smailBgimg1, forState: UIControlState.Normal)
        vipCardButton.setBackgroundImage(smailBgimgSelected1, forState: UIControlState.Highlighted)
        scrollView.addSubview(vipCardButton)
        
        let saleButton = CustomGrid(frame: CGRectMake(UIUtil.screenWidth/3, 0 + 130, UIUtil.screenWidth/3 - 0.8, 130 - 0.8), image: UIImage(named: "sale")!, title: "促销", detailTitle: "30项")
        saleButton.setBackgroundImage(smailBgimg1, forState: UIControlState.Normal)
        saleButton.setBackgroundImage(smailBgimgSelected1, forState: UIControlState.Highlighted)
        scrollView.addSubview(saleButton)
        
        let takeawayButton = CustomGrid(frame: CGRectMake(UIUtil.screenWidth/3*2, 0 + 130, UIUtil.screenWidth/3, 130 - 0.8), image: UIImage(named: "bike")!, title: "外卖", detailTitle: "30份")
        takeawayButton.setBackgroundImage(smailBgimg1, forState: UIControlState.Normal)
        takeawayButton.setBackgroundImage(smailBgimgSelected1, forState: UIControlState.Highlighted)
        scrollView.addSubview(takeawayButton)
        
        
        if isFirstLogin {
            balanceButton.mDetailTitleLabel?.text = "\(user.balance)"
            backMoneyButton.mDetailTitleLabel?.text = "\(user.backMoney)"
        }
        
    }
    
    
    func didPressOrderBarItem(sender: UIView) {
        gotoOrderListTableView()
    }
    
    func gotoOrderListTableView() {
        
        isNextLevel = true
        self.hidesBottomBarWhenPushed = true
        
        let viewController = OrderListViewController()
        viewController.user = self.user
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func didPressOrderButton(sender: UIButton) {
        gotoOrderView()
    }
    
    func gotoOrderView() {
        
        isNextLevel = true
        self.hidesBottomBarWhenPushed = true
        
        let orderViewController = OrderViewController()
        orderViewController.user = self.user
        self.navigationController?.pushViewController(orderViewController, animated: true)
        
    }
    
    func gotoTakeawayView(sender: UIButton) {
        let takeawayViewController = TakeawayViewController()
        self.navigationController?.pushViewController(takeawayViewController, animated: true)
    }
    
    
    /* 初始化大方块按钮 */
    func initHeadBtn(btn: CustomGrid, title: String, img: UIImage, x: CGFloat, y: CGFloat) {
        // 宽度＋1是为了防止在绘制图标时，两个btn之间产生的白隙
        btn.frame = CGRect(x: x, y: y, width: UIUtil.screenWidth/2 + 1, height: headButtonHeight)
//        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(HEAD_BTN_FONT_SIZE)
        
        let img1 = btn.buttonImageFromColor(UIUtil.navColor)
        let img2 = btn.buttonImageFromColor(UIUtil.navColorPressed)
        btn.setBackgroundImage(img1, forState: UIControlState.Normal)
        btn.setBackgroundImage(img2, forState: UIControlState.Highlighted)
        
//        btn.setImage(img, forState: UIControlState.Normal)
//        btn.mImage = UIImageView(image: img)
        
        btn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.title = "点菜啦"
        self.isNextLevel = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if isNextLevel {
            self.title = ""
        }
        self.hidesBottomBarWhenPushed = false
        
    }
    
    func setUser(user : User) {
        self.user = user
        
        if !isFirstLogin {
            balanceButton.mDetailTitleLabel?.text = "\(user.balance)"
            backMoneyButton.mDetailTitleLabel?.text = "\(user.backMoney)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

