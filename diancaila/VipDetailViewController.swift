//
//  VipDetailViewController.swift
//  diancaila
//
//  Created by 罗楚健 on 14/12/22.
//  Copyright (c) 2014年 diancaila. All rights reserved.
//

import UIKit

class VipDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpProtocol, InputMoneyViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CustomActionSheetDelegate, UIAlertViewDelegate {
    
    var tableView: UITableView!
    
    var moneyPicker: UIPickerView?
    
    var httpController = HttpController()
    
    var topupAlertView: UIAlertView?
    
    var topupSuccessAlertView: UIAlertView?
    
    var waitIndicator = UIUtil.waitIndicator()
    
    var vipInfo: NSDictionary?
    
    var isVip = true
    
    // tableview数据源
    var data = [["会员", "余额", "返现"], ["充值"], ["消费"]]
    
    var detailData = [String]()
    
    // money Picker 数据源
    var moneyList = [String]()
    var selectedMoeny = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMoneyList() // 加载 充值 固定的金钱
        
        httpController.deletage = self
        
        self.title = "会员信息"
        
        self.view.backgroundColor = UIUtil.gray_system
        
        println(vipInfo)
        
        let name = vipInfo?.objectForKey("name") as String
        let money: String? = vipInfo?.objectForKey("money") as? String
        let money2: String? = vipInfo?.objectForKey("money2") as? String
        detailData.append(vipInfo?.objectForKey("name") as String)
        if money == nil {
            data = [["会员"], ["开卡"]]
            isVip = false
            
        } else {
            detailData.append(vipInfo?.objectForKey("money") as String)
            detailData.append(vipInfo?.objectForKey("money2") as String)
        }
        

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
    
    func loadMoneyList() {
        waitIndicator.startAnimating()
        self.view.addSubview(waitIndicator)
        self.view.userInteractionEnabled = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let shopId = defaults.objectForKey("shopId") as String
        httpController.onSearchMoneyList(HttpController.apiMoneyList(shopId))
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
                // 如果不是vip就只显示开卡
                if isVip {
                    
                    moneyPicker = UIPickerView(frame: CGRectMake(0, 0, UIUtil.screenWidth, 200))
                    moneyPicker?.dataSource = self
                    moneyPicker?.delegate = self
                    let sheet = CustomActionSheet(customView: moneyPicker!)
                    sheet.deletage = self
                    sheet.show()
                    
                } else {
                    let dic = NSMutableDictionary()
                    let defaults = NSUserDefaults.standardUserDefaults()
                    dic["clerk_shop_id"] = defaults.objectForKey("shopId") as String
                    dic["id"] = vipInfo?.objectForKey("id") as String
                    httpController.post3(HttpController.apiBecomeVip(), json: dic)
                    
                    waitIndicator.startAnimating()
                    self.view.addSubview(waitIndicator)
                    self.view.userInteractionEnabled = false
                }
                
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
        vipInfo = result["user_info"] as? NSDictionary
        
        detailData.removeAll(keepCapacity: false)
        
        
        if vipInfo?.objectForKey("money") as? String != nil {
            data = [["会员", "余额", "返现"], ["充值"], ["消费"]]
            isVip = true
            
            detailData.append(vipInfo?.objectForKey("name") as String)
            detailData.append(vipInfo?.objectForKey("money") as String)
            detailData.append(vipInfo?.objectForKey("money2") as String)
        }
        
        tableView.reloadData()
        
        
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    func didReceiveResults2(result: NSDictionary) {
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
        let error: String? = result["error"] as? String
        
        if result["error"] == nil {
            
            topupSuccessAlertView = UIAlertView(title: "充值成功", message: "", delegate: self, cancelButtonTitle: "确定")
            topupSuccessAlertView?.show()
        } else {
            let alert = UIAlertView(title: error, message: "", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    func didReceiveResults3(result: NSDictionary) {
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
        let error: String? = result["error"] as? String
        if error == nil {
            reloadData()
        } else {
            let alert = UIAlertView(title: error, message: "", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    func didReceiveMoneyList(result: NSDictionary) {
        if result["error"] == nil {
            let data = result["money_info"] as NSArray
            
            for money in data {
                let tempMoney = money as NSDictionary
                let moneyString = tempMoney["money"] as String
                moneyList.append(moneyString)
            }
        }
        
        waitIndicator.stopAnimating()
        waitIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    
    // MARK: - InputMoneyViewControllerDelegate
    func inputMoneyDidFinish() {
        reloadData()
    }
    
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moneyList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return moneyList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMoeny = moneyList[row]
    }
    
    
    // MARK: - CustomActionSheetDelegate
    func didPressDoneButton(view: UIView) {
        topupAlertView = UIAlertView(title: "确定充值 ¥\(selectedMoeny)", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        topupAlertView?.show()
    }

    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == topupAlertView {
            
            if buttonIndex == 1 {
                let jsonDic = NSMutableDictionary()
                
                let defaults = NSUserDefaults.standardUserDefaults()
                jsonDic["mid"] = defaults.objectForKey("userId") as String
                jsonDic["id"] = vipInfo?.objectForKey("id")
                jsonDic["money"] = selectedMoeny
                jsonDic["action"] = "+"
                
                httpController.post2(HttpController.apiCharge(), json: jsonDic)
                
                
                waitIndicator.startAnimating()
                self.view.addSubview(waitIndicator)
                self.view.userInteractionEnabled = false
            }
        } else if alertView == topupSuccessAlertView {
            
            if buttonIndex == 0 {
                reloadData()
            }
        }
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
