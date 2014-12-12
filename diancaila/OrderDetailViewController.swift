//
//  OrderDetailViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/4.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HttpProtocol, SettleViewControllerDeletage, OrderViewControllerDeletage {
    
    var orderListTableView: UITableView!
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var priceLabel: UILabel!
    
    var vipPriceLabel:UILabel!
    
    let httpController = HttpController()
    
    // 由上一层传入
    var orderId: String!
    var deskId: Int!
    
    // 当前获取
    var truePrice: Double?
    
    // 数据源
    var orderDetail = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(deskId)号桌"
        
        httpController.deletage = self
        
        
        if truePrice == nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "加菜", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressAddFoodButton:")
            
        }

        orderListTableView  = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, UIUtil.screenHeight - UIUtil.contentOffset - 60), style: UITableViewStyle.Grouped)
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        self.view.addSubview(orderListTableView)
        
        
        // 结账栏 ---------------
        let settleView = UIView(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 60 , UIUtil.screenWidth, 60))
        settleView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(settleView)
        
        // 结账按钮 / 显示结账后金额
        let settleButton = UIButton(frame: CGRectMake(220, 0, UIUtil.screenWidth - 220, 60))
        let color = UIColor(red: 0.98431, green: 0.31764, blue: 0.03137, alpha: 0.9)
        settleButton.backgroundColor = color
        settleView.addSubview(settleButton)
        
        // 判断已结账还是未结账
        if (truePrice != nil) {
            settleButton.setTitle("\(truePrice!)", forState: UIControlState.Normal)
            
            // 订单号
            let priceLabel = UILabel(frame: CGRectMake(10, 0, 200, 60))
            priceLabel.textAlignment = NSTextAlignment.Center
            priceLabel.text = "订单号: \(orderId)"
            settleView.addSubview(priceLabel)
            
        } else {
            // 原价
            priceLabel = UILabel(frame: CGRectMake(0, 0, 100, 60))
            priceLabel.textAlignment = NSTextAlignment.Center
            priceLabel.text = "原: 0"
            settleView.addSubview(priceLabel)
            // 会员价
            vipPriceLabel = UILabel(frame: CGRectMake(100, 0, 100, 60))
            vipPriceLabel.textAlignment = NSTextAlignment.Center
            vipPriceLabel.text = "VIP: 0"
            settleView.addSubview(vipPriceLabel)

            
            settleButton.setTitle("结账", forState: UIControlState.Normal)
            settleButton.addTarget(self, action: "didPressSettleButton:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        // 横分割线
        let hDivide = UIView(frame: CGRectMake(0, UIUtil.screenHeight - UIUtil.contentOffset - 60, UIUtil.screenWidth, 1))
        hDivide.backgroundColor = UIColor.grayColor()
        hDivide.alpha = 0.3
        self.view.addSubview(hDivide)
        
        loadData()
       
    }
    
    func didPressAddFoodButton(sender: UIBarButtonItem) {
        let orderViewCV = OrderViewController()
        orderViewCV.delegate = self
        orderViewCV.orderId = orderId
        self.navigationController?.pushViewController(orderViewCV, animated: true)
    }
    
    func didPressSettleButton(sender: UIButton) {
        let settleVC = SettleViewController()
        settleVC.orderId = orderId
        settleVC.deletage = self
        self.navigationController?.presentViewController(settleVC, animated: true, completion: nil)
    }
    
    
    func loadData() {
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.bringSubviewToFront(waitIndicator)
        self.view.userInteractionEnabled = false
        
        // 获取前 清空
        orderDetail.removeAllObjects()
        
        httpController.onSearchOrderDetailById(orderId, url: HttpController.apiOrderDetail)
    }
    
    // UITableViewDelegate  UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderDetail.count == 0 {
            return 0
        } else {
            let list = orderDetail["list"] as NSArray
            return list.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderDetailCell = "orderDetailCell"
//        var cell = tableView.dequeueReusableCellWithIdentifier(orderDetailCell) as UITableViewCell
        
        // todo 报错我也是醉了
//        if cell == nil {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: orderDetailCell)
//        }
        
        //* json 模版 ------------------------------------------------------------------------------------------------
        //{"order_id":"1-1-20141203165755-6910","list":[{"dish_id":"9","dish_name":"肉龙","num":"1","totalprice":"28"},{"dish_id":"10","dish_name":"三不馆er招牌香香骨（小）","num":"1","totalprice":"68"},{"dish_id":"11","dish_name":"三不馆er招牌香香骨（中）","num":"1","totalprice":"102"}]}
        
        let orderItem = (orderDetail["list"] as NSArray)[indexPath.row] as NSDictionary
        cell.textLabel?.text = orderItem["dish_name"] as? String
        let price = orderItem["price"] as String
        let vipPrice = orderItem["vip_price"] as String
        let num = orderItem["num"] as String
        cell.detailTextLabel?.text = "\(price) / \(vipPrice)   x \(num)"
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // HttpProtocol
    func didReceiveOrderDetail(result: NSMutableDictionary) {
        orderDetail = result
        
        orderListTableView.reloadData()
        
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
        if (truePrice == nil) {
            let totalPrice = orderDetail["totalprice"] as String
            let vipPrice = orderDetail["vip_totalprice"] as String
            priceLabel.text =   "原: \(totalPrice)"
            vipPriceLabel.text = "VIP: \(vipPrice)"
        }
    }
    

    // SettleViewControllerDeletage
    func didSettle() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // OrderViewControllerDeletage
    func didAddFood() {
       loadData()
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
