//
//  OrderDetailViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/4.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HttpProtocol {
    
    var orderListTableView: UITableView!
    
    let httpController = HttpController()
    
    // 由上一层传入
    var orderId: String!
    var price: Double!
    var vipPrice: Double!
    
    // 数据源
    var orderDetail = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpController.deletage = self
        
        loadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "结账", style: UIBarButtonItemStyle.Bordered, target: self, action: "didPressSettleButton:")

        orderListTableView  = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Grouped)
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        self.view.addSubview(orderListTableView)
        
        
        let priceLabel = UILabel(frame: CGRectMake(self.view.frame.width/2, self.view.frame.height/5*3, 150, 50))
        priceLabel.text = "\(price)"
        self.view.addSubview(priceLabel)
        
        let vipPriceLabel = UILabel(frame: CGRectMake(self.view.frame.width/2, self.view.frame.height/5*4, 150, 50))
        vipPriceLabel.text = "\(vipPrice)"
        self.view.addSubview(vipPriceLabel)
        
        
    }
    
    func didPressSettleButton(sender: UIBarButtonItem) {
        let settleAlert = UIAlertView(title: "aaa", message: "aaa", delegate: self, cancelButtonTitle: "取消")
        settleAlert.show()
    }
    
    
    func loadData() {
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
        //{"order_id":"1-1-20141203165755-6910","list":[{"dish_id":"9","dish_name":"肉龙","num":"1","totalprice":"28"},{"dish_id":"10","dish_name":"三不馆er招牌香香骨（小）","num":"1","totalprice":"68"},{"dish_id":"11","dish_name":"三不馆er招牌香香骨（中）","num":"1","totalprice":"102"}]}
        
        cell.textLabel?.text = ((orderDetail["list"] as NSArray)[indexPath.row] as NSDictionary)["dish_name"] as? String
        
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // HttpProtocol
    func didReceiveOrderDetail(result: NSMutableDictionary) {
        orderDetail = result
        
        orderListTableView.reloadData()
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
