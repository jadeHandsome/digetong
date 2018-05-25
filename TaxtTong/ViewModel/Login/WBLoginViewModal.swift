//
//  WBLoginViewModal.swift
//  TaxtTong
//
//  Created by ling on 2017/7/4.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBLoginViewModal {
    
    //获取用户信息
    func getUserInfo(completion:@escaping (_ isSuccess: Bool)->()) {
        
        var paramers = [String: AnyObject]();
        let sec = WBUserinfoManager.shared.getUserInfoModal().sec as AnyObject
        paramers["uid"] = WBUserinfoManager.shared.getUserInfoModal().uid as AnyObject
        paramers["sec"] = sec
        WBNetworkManager.shared.requestUserInfo(parameters: paramers) { (dic, isSuccess) in
            if isSuccess{
                var newDic = dic
                newDic["sec"] = sec
                print("newDic: \(newDic)")
                WBUserinfoManager.shared.saveUserInfoModal(dict: newDic)
                
                if let tid = newDic["tid"]{
                    let tidStr = "comp"+String(describing: tid)
                    JPUSHService.setTags([tidStr], completion: nil, seq: 0)
                }
                if let uid = newDic["uid"]{
                    let uidStr = String(describing: uid)
                    JPUSHService.setAlias(uidStr, completion: nil, seq: 0)
                }
                completion(isSuccess)
            }
        }
    }
    
    //登录
    func login(phone: String, pwd: String, isSave:Bool, completion:@escaping (_ isSuccess: Bool)->()) {
        
        if phone.characters.count == 0 {
           SVProgressHUD.showError(withStatus: "手机号码不能为空")
           return
        }
        
        if pwd.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "密码不能为空")
            return
        }
        
        if !Tool.isMobileNumberClassification(phone) {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
            return
        }
        
        var paramers = [String: AnyObject]();
        paramers["phone"] = phone as AnyObject;
        paramers["pwd"] = Tool.md5(pwd) as AnyObject
        
        WBNetworkManager.shared.loginAct(parameters: paramers) { (isSuccess, dic ,errStr) in
            if(isSuccess){
                if let mUid = dic?["uid"] as? String,
                   let mSec = dic?["sec"] as? String{
                    //存储sec
                    let userInfo = WBUserinfoManager.shared.getUserInfoModal()
                    userInfo.uid = Int64(mUid)!
                    userInfo.sec = String(mSec)
                    WBUserinfoManager.shared.saveUserInfoModal(userInfo: userInfo)
                    
                }
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                
                completion(true)
            }else{
                SVProgressHUD.showError(withStatus: errStr)
            }
        }
    }
    
    //注册
    func register(phone: String, pwd: String, rpwd: String, yzm: String, isAllow:Bool, completion:@escaping (_ isSuccess: Bool)->()) {
        
        if phone.characters.count == 0 || pwd.characters.count == 0  {
            SVProgressHUD.showError(withStatus: "帐号密码不能为空")
            return
        }
        
        if !Tool.isMobileNumberClassification(phone) {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
            return
        }
    
        if pwd != rpwd {
            SVProgressHUD.showError(withStatus: "密码不一致")
            return
        }
        
        
        if yzm.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "验证码不能为空")
            return
        }
        
        if !isAllow {
            SVProgressHUD.showError(withStatus: "请勾选用户许可协议")
            return
        }

        
        var paramers = [String: AnyObject]();
        paramers["phone"] = phone as AnyObject;
        paramers["pwd"] = Tool.md5(pwd) as AnyObject
        paramers["yzm"] = yzm as AnyObject
        
        WBNetworkManager.shared.regiestAct(parameters: paramers) { (isSuccess ,errStr) in
            if(isSuccess){
                SVProgressHUD.showSuccess(withStatus: "注册成功，请登录")
                completion(true)
            }else{
                SVProgressHUD.showError(withStatus: errStr)
            }
        }
    
    }

    //找回密码
    func forgetPwd(phone: String, pwd: String, rpwd: String, yzm: String, isAllow:Bool, completion:@escaping (_ isSuccess: Bool)->()) {
        
        if phone.characters.count == 0 || pwd.characters.count == 0  {
            SVProgressHUD.showError(withStatus: "帐号密码不能为空")
            return
        }
        
        if !Tool.isMobileNumberClassification(phone) {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
            return
        }
        
        if pwd != rpwd {
            SVProgressHUD.showError(withStatus: "密码不一致")
            return
        }
        
        
        if yzm.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "验证码不能为空")
            return
        }
        
        if !isAllow {
            SVProgressHUD.showError(withStatus: "请勾选用户许可协议")
            return
        }
        
        
        var paramers = [String: AnyObject]();
        paramers["phone"] = phone as AnyObject;
        paramers["pwd"] = Tool.md5(pwd) as AnyObject
        paramers["yzm"] = yzm as AnyObject
        
        WBNetworkManager.shared.forgetPwdAct(parameters: paramers) { (isSuccess ,errStr) in
            if(isSuccess){
                SVProgressHUD.showSuccess(withStatus: "找回密码成功，请重新登录")
                completion(true)
            }else{
                SVProgressHUD.showError(withStatus: errStr)
            }
        }
        
    }
    
    //退出登录
    func logout() {
        
        let uid = WBUserinfoManager.shared.userInfo.uid
        let sec = WBUserinfoManager.shared.userInfo.sec
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = uid as AnyObject;
        paramers["sec"] = sec as AnyObject
        
        WBNetworkManager.shared.logoutAct(parameters: paramers) { (isSuccess, errStr) in
            let userInfo = WBUserinfoManager.shared.userInfo
            userInfo.uid = 0
            userInfo.sec = ""
            WBUserinfoManager.shared.saveUserInfoModal(userInfo: userInfo)
        }
        
        
    }
    
    
    //获取验证码
    func getYzm(phone: String, completion:@escaping (_ isSuccess: Bool)->()) {
        
        if phone.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "手机号码不能为空")
            return
        }
        
        
        if !Tool.isMobileNumberClassification(phone) {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号码")
            return
        }
  
        WBNetworkManager.shared.requestYZMAct(phone: phone) { (isSuccess, errStr) in
            if(isSuccess){
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                completion(isSuccess)
            }else{
                SVProgressHUD.showError(withStatus: errStr)
            }
        }
    }
    
    
}

