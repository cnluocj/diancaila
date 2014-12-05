//
//  AppDelegate.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/12.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var rootView: ViewController!
    var navController: UINavigationController!
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 改变状态栏字体颜色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.rootView = ViewController()
        self.rootView = ViewController()
        
        self.navController = getNavController()
        navController.pushViewController(rootView, animated: true)
        
        self.window?.addSubview(navController.view)
        self.window?.makeKeyAndVisible()
        
        return true
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
    


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

