//
//  WBCompanyViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/27.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBCompanyViewController: WBBaseViewController {

    @IBOutlet weak var mTableView: UITableView!
    var headView: WBCompayHeaderView!
    
    var cellID = "WBCompanyNotifCell"
    var isNotif = true
    var logoInfo = [String: AnyObject]()
    var listArr = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI();
    }
    
    deinit {
        NotificationCenter().removeObserver(self)
    }

}

extension WBCompanyViewController {
    
    func renderUI() {
        navigationItem.title = "的哥通"
        mTableView?.tableFooterView = UIView.init(frame: CGRect.zero)
        registerNib(isTitle: true)
        
        navItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "cmp_menu"), style: .plain, target: self, action: #selector(clickMenuItem))
        
        if let headView = WBCompayHeaderView.newInstance(){
            headView.frame = CGRect(x: 0, y: 0, width: UIScreen().get_ScreenWidth(), height: 340)
            headView.cellTypeLabel.text = "通知"
            self.headView = headView
        }
        
        NotificationCenter().addObserve(target: self, selector: #selector(clickHeaderBtn(notification:)), name: SEND_COMPANY_HEADER_BTN)
        
        //请求logo数据
        WBNetworkManager.shared.requestCompanyLogo { (dic, isSuccess) in
            if isSuccess{
                if let img = dic["img"] {
                    self.headView.headerView.sd_setImage(with: URL.init(string: img as! String))
                }
                self.logoInfo = dic;
            }else{
                let vc = WBAddCompanyController.init()
                vc.tabBarItem.image = UIImage(named: "tabbar_gongsi")
                vc.tabBarItem.selectedImage = UIImage(named: "tabbar_gongsi_highlighted")?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().getMainColor()], for: .highlighted)
                let nav = WBNavigatorController(rootViewController: vc)
                var vcArr = self.tabBarController?.viewControllers
                vcArr?.replaceSubrange(Range(1..<2), with: [nav])
                self.tabBarController?.setViewControllers(vcArr, animated: true)
            }
        }

        //请求列表数据
        requestList(type: "noticelist")

    }

    func clickMenuItem(){
        navigationController?.pushViewController(WBAddCompanyController.init(type: .JOIN), animated: true)
    }
    
    func registerNib(isTitle: Bool) {
        isNotif = isTitle
        if isNotif {
            cellID = "WBCompanyNotifCell"
        }else{
            cellID = "WBCompayPicCell"
        }
        mTableView?.register(UINib.init(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func requestList(type: String!) {
        WBNetworkManager.shared.requestCompanyNotifList(type: type) { (arr, isSuccess) in
            self.listArr = arr
            self.mTableView.reloadData()
        }
    }
    
    func clickHeaderBtn(notification: Notification) {
        let userInfo = notification.userInfo
        let tag = userInfo?["tag"] as! Int
        var type = "noticelist";
        var typeStr = "通知"
        switch (tag) {
            case 0:
                type="noticelist"; //通知
                typeStr = "通知"
                break;
            case 1:
                type="affichelist";//公告
                typeStr = "公告"
                break;
            case 2:
                type="meetinglist";//会议
                typeStr = "会议"
                break;
            case 5:
                type="vehiclelist";//车管
                typeStr = "车管"
                break;
            case 6:
                type="trafficlist";//交管
                typeStr = "交管"
                break;
            case 7:
                type="customerlist";//客管
                typeStr = "客管"
                break;
            case 8:
                type="picturelist";//图片
                typeStr = "图片"
                break;
            default:
                break;
        }
        headView.cellTypeLabel.text = typeStr
        if tag == 4 || tag == 9 {
            var hid = 0
            if tag == 4 {
                hid = logoInfo["profile_hid"] as? Int ?? 0
            }
            if tag == 9 {
                hid = logoInfo["contact_hid"] as? Int ?? 0
            }
            if hid != 0 {
                let webView = WBWebViewController(hid: Int64(hid))
                navigationController?.pushViewController(webView, animated: true)
            }
            return
        }
        
        if tag == 3 {
            print("跳去咨询")
            navigationController?.pushViewController(WBConsultListController(), animated: true)
            return
        }
        
        if tag == 8 {
            print("显示图片")
            registerNib(isTitle: false)
           
        }else{
            print("显示title")
            registerNib(isTitle: true)
        }
         mTableView.reloadData()
        
        //请求数据
        requestList(type: type)
        
    }
    
}

extension WBCompanyViewController : UITableViewDelegate,UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = cellID;
        if isNotif {
            var cell = WBCompanyNotifCell()
            cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WBCompanyNotifCell
            cell.viewModal = item
            return cell
        }else{
            var cell = WBCompayPicCell()
            cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBCompayPicCell
            cell.viewModal = item
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = listArr[indexPath.row]
        if let hid = item["hid"] as? Int64 {
            let webView = WBWebViewController(hid: hid)
            navigationController?.pushViewController(webView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  headView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 380
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isNotif {
            return 44
        }else{
            return 100
        }
    }
    
}
