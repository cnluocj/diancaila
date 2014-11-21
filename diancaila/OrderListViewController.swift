//
//  OrderListViewController.swift
//  diancailaUIdemo
//
//  Created by 罗楚健 on 14/11/18.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        let backButton = UIButton(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight/2))
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
//        let img = UIUtil.imageFromColor(UIUtil.screenWidth, height: UIUtil.screenHeight/2, color: color)
        backButton.backgroundColor = color
        backButton.setTitle("back", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
