//
//  VipDetailViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/22.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class VipDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpProtocol, InputMoneyViewControllerDelegate {
    
    var vipInfo: NSDictionary?
    
    var tableView: UITableView!
    
    var httpController = HttpController()
    
    var waitIndicator = UIUtil.waitIndicator()
    
    // 数据源
    var data = [["会员", "余额", "返现"], ["充值"], ["付款"]]
    
    var detailData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpController.deletage = self
        
        self.title = "会员信息"
        
        self.view.backgroundColor = UIUtil.gray_system
        
        
        detailData.append(vipInfo?.objectForKey("name") as String)
        detailData.append(vipInfo?.objectForKey("money") as String)
        detailData.append(vipInfo?.objectForKey("money2") as String)

        tableView = UITableView(frame: CGRectMake(0, 0, UIUtil.screenWidth, UIUtil.screenHeight - UIUtil.contentOffset), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }

    func gotoInputMoneyVC(actionType: InputMoneyActionType, actionTilte: String, url: String) {
        let vc = InputMoneyViewController()
        vc.delegate = self
        vc.vipId = vipInfo!.objectForKey("id") as? String
        vc.actionTitle = actionTilte
        vc.actionType = actionType
        vc.postUrl = url
        
//        let nav = UIUtil.navController()
//        nav.pushViewController(vc, animated: true)
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func reloadData() {
        
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.userInteractionEnabled = false
        
        let jsonDic = NSMutableDictionary()
        jsonDic["phone"] = vipInfo?.objectForKey("phone") as String
        httpController.post(HttpController.apiUserInfo(), json: jsonDic)
    }
    
    // MARK: - UITableViewDelegate UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "")
            cell.detailTextLabel?.text = detailData[indexPath.row]
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                gotoInputMoneyVC(InputMoneyActionType.plus, actionTilte: "充值", url: HttpController.apiCharge())
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                gotoInputMoneyVC(InputMoneyActionType.subtract, actionTilte: "付账", url: HttpController.apiCharge())
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: - HttpProtocol
    func didReceiveResults(result: NSDictionary) {
        let info = result["user_info"] as NSDictionary
        
        detailData.removeAll(keepCapacity: false)
        detailData.append(info.objectForKey("name") as String)
        detailData.append(info.objectForKey("money") as String)
        detailData.append(info.objectForKey("money2") as String)
        
        tableView.reloadData()
        
        
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    
    // MARK: - InputMoneyViewControllerDelegate
    func inputMoneyDidFinish() {
        reloadData()
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
