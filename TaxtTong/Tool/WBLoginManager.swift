//
//  WBLoginManager.swift
//  TaxtTong
//
//  Created by ling on 2017/9/17.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBLoginManager: NSObject {

    //单例
    static let shared =  WBLoginManager();
    
    var loginInfo = WBLogin()
    
    //存储数据
    func getLoginInfoModal()  -> WBLogin {
        
        if let jsonStr = UserDefaults().getUserDefaults(key: LOGIN_MESSAGE_KEY) as? String{
            loginInfo = WBLogin.deserialize(from: jsonStr)!
        }
        return loginInfo
        
    }
    
    //存储全部数据
    func saveLoginInfoModal(loginInfo: WBLogin) {
        UserDefaults().saveUserDefaults(key: LOGIN_MESSAGE_KEY, value: loginInfo.toJSONString())
        
        
    }
    
}
