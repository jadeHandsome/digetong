//
//  WBUserinfoManager.swift
//  TaxtTong
//
//  Created by ling on 2017/7/4.
//  Copyright © 2017年 ling. All rights reserved.
//

import Foundation

class WBUserinfoManager {
    
    //单例
    static let shared =  WBUserinfoManager();
    
    var userInfo = WBUser()
    
    //存储数据
    func getUserInfoModal()  -> WBUser {
        
        if let jsonStr = UserDefaults().getUserDefaults(key: MY_MESSAGE_KEY) as? String{
            userInfo = WBUser.deserialize(from: jsonStr)!
        }
        
        return userInfo
        
    }
    
    //存储全部数据
    func saveUserInfoModal(dict: [String: AnyObject]) {
        
        userInfo = WBUser.deserialize(from: dict as NSDictionary)!
        UserDefaults().saveUserDefaults(key: MY_MESSAGE_KEY, value: userInfo.toJSONString())

    }
    
    //存储全部数据
    func saveUserInfoModal(userInfo: WBUser) {
        
        UserDefaults().saveUserDefaults(key: MY_MESSAGE_KEY, value: userInfo.toJSONString())
        
        
    }
    
    //移除数据
    func removeUserInfoModal() {
        UserDefaults().removeObject(forKey: MY_MESSAGE_KEY)
    }
}
