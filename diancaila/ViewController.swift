//
//  ViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    /* 点餐按钮 */
    let orderBtn: CustomGrid = CustomGrid()
    
    /* 外卖按钮 */
    let takeawayBtn: CustomGrid = CustomGrid()
    
    
    /* 导航栏高度 */
    var navHeight: CGFloat!
    
    /* 屏幕顶部到内容的距离 */
    var topMargin: CGFloat!
    
    /* 大方块的字体大小 */
    let HEAD_BTN_FONT_SIZE = CGFloat(20)
    
    /* 大方块高度 */
    let HEAD_BTN_FONT_HEIGHT = CGFloat(120)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "点菜啦"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // 设置状态栏字体颜色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // 导航栏高度，如果没有导航栏，高度为0
        navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        topMargin = navHeight + UIUtil.statusHeight
        
        // 点餐按钮
        initHeadBtn(orderBtn, title: "点餐", img: UIImage(named: "order")!, x: 0.0, y: 0)
        orderBtn.addTarget(self, action: "didPressOrderButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(orderBtn)
        
        // 外卖按钮
        let img2 = UIUtil.scaleToSize(UIImage(named: "regular_biking-100")!, size: CGSize(width: 50, height: 50))
        initHeadBtn(takeawayBtn, title: "外卖", img: img2, x: UIUtil.screenWidth/2, y: 0)
        takeawayBtn.addTarget(self, action: "gotoTakeawayView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(takeawayBtn)
        
        
        let orderBarItem = UIBarButtonItem(title: "订单", style: UIBarButtonItemStyle.Plain, target: self, action: "didPressOrderBarItem:")
        orderBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = orderBarItem
    }
    
    
    func didPressOrderBarItem(sender: UIBarButtonItem) {
        gotoOrderListTableView()
    }
    
    func gotoOrderListTableView() {
        
        self.title = ""
        
        let viewController = OrderListViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didPressOrderButton(sender: UIButton) {
        gotoOrderView()
    }
    
    func gotoOrderView() {
        
        let orderViewController = OrderViewController()
        self.navigationController?.pushViewController(orderViewController, animated: true)
        
    }
    
    func gotoTakeawayView(sender: UIButton) {
        let takeawayViewController = TakeawayViewController()
        self.navigationController?.pushViewController(takeawayViewController, animated: true)
    }
    
    
    /* 初始化大方块按钮 */
    func initHeadBtn(btn: CustomGrid, title: String, img: UIImage, x: CGFloat, y: CGFloat) {
        // 宽度＋1是为了防止在绘制图标时，两个btn之间产生的白隙
        btn.frame = CGRect(x: x, y: y, width: UIUtil.screenWidth/2 + 1, height: HEAD_BTN_FONT_HEIGHT)
//        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(HEAD_BTN_FONT_SIZE)
        
        let img1 = btn.buttonImageFromColor(UIUtil.navColor)
        let img2 = btn.buttonImageFromColor(UIUtil.navColorPressed)
        btn.setBackgroundImage(img1, forState: UIControlState.Normal)
        btn.setBackgroundImage(img2, forState: UIControlState.Highlighted)
        
        btn.setImage(img, forState: UIControlState.Normal)
        
        
        btn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.title = "点菜啦"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

