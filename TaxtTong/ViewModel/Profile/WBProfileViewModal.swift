//
//  WBProfileViewModal.swift
//  TaxtTong
//
//  Created by ling on 2017/8/19.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBProfileViewModal: NSObject {

    //获取个人信息
    func setUserInfo(nickname: String, completion:@escaping (_ isSuccess: Bool)->()) {
        
        let nickname = WBUserinfoManager.shared.getUserInfoModal().nickname
        let linkphone = WBUserinfoManager.shared.getUserInfoModal().linkphone
        let platenumber = WBUserinfoManager.shared.getUserInfoModal().platenumber
        let name = WBUserinfoManager.shared.getUserInfoModal().name
        let credentials = WBUserinfoManager.shared.getUserInfoModal().credentials
        
        let isExit: Bool = nickname == NULL || linkphone == NULL ||  platenumber == NULL ||  name == NULL || credentials == NULL
        
        if isExit {
            SVProgressHUD.showError(withStatus: "信息不能为空")
        }
        
        var paramers = [String: AnyObject]()
        paramers["uid"] = WBUserinfoManager.shared.getUserInfoModal().uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.getUserInfoModal().sec as AnyObject
        paramers["tid"] = WBUserinfoManager.shared.getUserInfoModal().tid as AnyObject
        paramers["nickname"] = nickname as AnyObject
        paramers["linkphone"] = linkphone as AnyObject
        paramers["platenumber"] = platenumber as AnyObject
        paramers["name"] = name as AnyObject
        paramers["credentials"] = credentials as AnyObject
       
        
        print(paramers)
//        WBNetworkManager.shared.setUserInfo(parameters: paramers) { (dic) in
//            
//            print(dic)
//            
//        }
    }
    

}



