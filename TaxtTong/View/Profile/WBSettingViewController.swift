//
//  WBSettingViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/15.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD


class WBSettingViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
    }

    @IBAction func clickButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            navigationController?.pushViewController(WBFeedbackViewController(), animated: true)
        case 1:
            SVProgressHUD.showInfo(withStatus: "当前版本为最新")
        case 2:
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                SVProgressHUD.showSuccess(withStatus: "清除完毕")
            }
        case 3:
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://www.digetong.com")!, options: [:], completionHandler: { (success) in
                    
                })
            } else {
                 UIApplication.shared.openURL(URL.init(string: "http://www.digetong.com")!)
            }
        case 4:
            navigationController?.pushViewController(WBContactViewController(), animated: true)
        case 5:
            navigationController?.pushViewController(WBUserBookViewController(), animated: true)
        case 6:
            exitTaxi()
        case 7:
            navigationController?.pushViewController(RegisterViewController(type: .ForgetPwd), animated: true)
        case 8:
            logout()
        default:
            break
        }
    }

    
}

extension WBSettingViewController {
    
    func renderUI() {
        
        title = "设置"
    
    }
    
    //退出出租车司机
    func exitTaxi() {
        let tid = WBUserinfoManager.shared.userInfo.tid
        if tid == nil || tid == NULL  {
            SVProgressHUD.showError(withStatus: "您还没加入公司")
            return
        }
        
        WBNetworkManager.shared.requestExitCompany { (isSuccess) in
            if isSuccess {
                 SVProgressHUD.showSuccess(withStatus: "退出成功")
                
                 WBLoginViewModal().getUserInfo(completion: { (isSuccess) in
                 
                    JPUSHService.setTags(["00000"], completion: nil, seq: 0)
                    
                    let vc = WBAddCompanyController.init()
                    vc.title = "公司"
                    vc.tabBarItem.image = UIImage(named: "tabbar_gongsi")
                    vc.tabBarItem.selectedImage = UIImage(named: "tabbar_gongsi_highlighted")?.withRenderingMode(.alwaysOriginal)
                    vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().getMainColor()], for: .highlighted)
                    let nav = WBNavigatorController(rootViewController: vc)
                    var vcArr = self.tabBarController?.viewControllers
                    vcArr?.replaceSubrange(Range(1..<2), with: [nav])
                    self.tabBarController?.setViewControllers(vcArr, animated: true)
                 })
            }
        }
        
    }
    
    //退出登录
    func logout() {
        WBLoginViewModal().logout();
        JPUSHService.setAlias("000000", completion: nil, seq: 0)
        let userInfo = WBUserinfoManager.shared.getUserInfoModal()
        let loginInfo = WBLoginManager.shared.getLoginInfoModal()
        if loginInfo.isSave {
            if userInfo.phone != NULL {
                loginInfo.phone = userInfo.phone
            }
            loginInfo.himg = userInfo.himg
            WBLoginManager.shared.saveLoginInfoModal(loginInfo: loginInfo)
        }else{
            WBUserinfoManager.shared.removeUserInfoModal()
        }
        view.window?.rootViewController = WBNavigatorController(rootViewController: WBLoginViewController())
    }
}
