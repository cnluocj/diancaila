//
//  HomeViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    var mainNavController: UINavigationController!
    
    var discoverNavController: UINavigationController!
    
    var meNavController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor.orangeColor()
        
        // 首页
        let mainViewController = ViewController()
        mainNavController = getNavController()
        mainNavController.pushViewController(mainViewController, animated: true)
        let mainTabItem = UITabBarItem(title: "首页", image: UIImage(named: "restaurant"), selectedImage: UIImage(named: "restaurant_selected"))
        mainViewController.tabBarItem = mainTabItem
        
        // 发现
        let discoverViewController = DiscoverViewController()
        discoverNavController = getNavController()
        discoverNavController.pushViewController(discoverViewController, animated: true)
        let discoverTabItem = UITabBarItem(title: "发现", image: UIImage(named: "discover"), selectedImage: UIImage(named: "discover_selected"))
        discoverViewController.tabBarItem = discoverTabItem
        
        // 我
        let meViewController = MeViewController()
        meNavController = getNavController()
        meNavController.pushViewController(meViewController, animated: true)
        let meTabItem = UITabBarItem(title: "我", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_selected"))
        meViewController.tabBarItem = meTabItem
        
        self.viewControllers = NSArray(objects: mainNavController, discoverNavController, meNavController)
    }
    
    func getNavController() ->UINavigationController{
        let navController = UINavigationController()
        //20为iphone状态栏高度
        let navImage = UIUtil.imageFromColor(UIUtil.screenWidth, height: navController.navigationBar.frame.height+20, color: UIUtil.navColor)
        // 改变背景颜色，使用生成的纯色图片
        navController.navigationBar.setBackgroundImage(navImage, forBarMetrics: UIBarMetrics.Default)
        // 主体是否从顶部开始/是否透明
        navController.navigationBar.translucent = false
        // 改变title颜色
        navController.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        // 改变导航栏上字体颜色，除了title
        navController.navigationBar.tintColor = UIColor.whiteColor()
        return navController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
