//
//  WBNetworkManager+Extension.swift
//  TaxtTong
//
//  Created by ling on 2017/7/3.
//  Copyright © 2017年 ling. All rights reserved.
//

import Foundation
import SVProgressHUD

extension WBNetworkManager {
    
    //登录
    func loginAct(parameters: [String: AnyObject], completion:@escaping (_ isSuccess: Bool,_ dic: [String: AnyObject]?,_ errStr: String?)->()) {
        
        let urlString =  Domin + "/user/login"
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: parameters) { (json, isSuccess) in
            
            var errStr = "登录失败"
            guard let dic = json as? [String: AnyObject]
            else{
                completion(false, nil, errStr)
                return
            }
            
            let codeStr = dic["code"] as? String ?? "400"
            let code = Int(codeStr) ?? 400
            print(code)
            if code == 200 {
                completion(true, dic, nil)
            }else{
                switch code {
                case 4003:
                    errStr = "用户密码错误"
                case 4002:
                    errStr = "用户不存在"
                case 4007:
                    errStr = "用户违规被禁止登陆"
                default:
                    errStr = "登录失败"
                }
                completion(false, nil, errStr)
            }
        }
    }

    //验证码
    func requestYZMAct(phone: String, completion:@escaping (_ isSuccess: Bool,_ errStr: String?)->()) {
        
        let urlString =  Domin + "/user/yzm"
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let red = Int(phone)! - timestamp
        let rem = red % 49477
        let m = Tool.md5(String(rem))!
        let index = m.index(m.startIndex, offsetBy: 16)
        let sec = m.substring(to: index)

        
        var paramers = [String: AnyObject]();
        paramers["phone"] = phone as AnyObject;
        paramers["utime"] = String(timestamp) as AnyObject
        paramers["sec"] = sec as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            let errStr = "发送失败"
            guard let dic = json as? [String: AnyObject]
                else{
                    completion(false, errStr)
                    return
            }
            
            let codeStr = dic["code"] as? String ?? "400"
            let code = Int(codeStr) ?? 400
            print(code)
            if code == 200 {
                completion(true, nil)
            }else{
                completion(false, errStr)
            }
        }
    }
    
    
    //注册
    func regiestAct(parameters: [String: AnyObject], completion:@escaping (_ isSuccess: Bool,_ errStr: String?)->()) {
        
        let urlString =  Domin + "/user/reg"
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: parameters) { (json, isSuccess) in
     
            var errStr = "注册失败"
            guard let dic = json as? [String: AnyObject]
                else{
                    completion(false, errStr)
                    return
            }
            
            let codeStr = dic["code"] as? String ?? "400"
            let code = Int(codeStr) ?? 400
            print(code)
            if code == 200 {
                completion(true, nil)
            }else{
                switch code {
                case 4001:
                    errStr = "短信验证码错误"
                case 4004:
                    errStr = "用户已被注册"
                default:
                    errStr = "登录失败"
                }
                completion(false, errStr)
            }
        }
    }
    

    //忘记密码
    func forgetPwdAct(parameters: [String: AnyObject], completion:@escaping (_ isSuccess: Bool,_ errStr: String?)->()) {
        
        let urlString =  Domin + "/user/pwd"
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: parameters) { (json, isSuccess) in
            
            var errStr = "找回失败"
            guard let dic = json as? [String: AnyObject]
                else{
                    completion(false, errStr)
                    return
            }
            
            let codeStr = dic["code"] as? String ?? "400"
            let code = Int(codeStr) ?? 400
            print(code)
            if code == 200 {
                completion(true, nil)
            }else{
                switch code {
                case 4001:
                    errStr = "短信验证码错误"
                case 4002:
                    errStr = "用户不存在"
                default:
                    errStr = "找回失败"
                }
                completion(false, errStr)
            }
        }
    }

    //退出登录
    func logoutAct(parameters: [String: AnyObject], completion:@escaping (_ isSuccess: Bool,_ errStr: String?)->()) {
        
        let urlString =  Domin + "/user/loginout"
        
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: parameters) { (json, isSuccess) in
 
            let errStr = "退出失败"
            guard let dic = json as? [String: AnyObject]
                else{
                    completion(false, errStr)
                    return
            }
            
            let codeStr = dic["code"] as? String ?? "400"
            let code = Int(codeStr) ?? 400
            print(code)
            if code == 200 {
                completion(true, nil)
            }else{
                completion(false, errStr)
            }
        }
    }
    
    //退出出租车公司
    func requestExitCompany(completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/signout"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["tid"] = WBUserinfoManager.shared.userInfo.tid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //获取用户信息  
    func requestUserInfo(parameters: [String: AnyObject], completion:@escaping (_ dic: [String: AnyObject],_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/user/getinfo"
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: parameters) { (json, isSuccess) in
            
            if(isSuccess){
                self.dealJson(json: json, completion: { (dic, code) in
                    if code == 400{
                        completion([:], false)
                    }else{
                        completion(dic, true)
                    }
                })
            }else{
                completion([:], false)
            }
            
            
        }
    }
    
    //设置用户信息
    func setUserInfo(parameters: [String: AnyObject], completion:@escaping (_ dic: [String: AnyObject])->()) {
        
        let urlString =  Domin + "/user/setinfo"
        
        WBNetworkManager.shared.request(method: .POST,URLString: urlString, parameters: parameters) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                
                if(code == 200){
                    completion(dic)
                }else{
                    completion([String: AnyObject]())
                }
            })
            
            
        }
    }
    
    // 设置头像
    func setHeadImg(imgStr: String, completion:@escaping (_ dic: [String: AnyObject])->()) {
        
        let urlString =  Domin + "/user/sethimg"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["himg"] = imgStr as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                
                if(code == 200){
                    SVProgressHUD.showSuccess(withStatus: "设置成功")
                    completion(dic)
                }
            })
            
            
        }
    }
    
    //我的消息
    func requestMyMessage(completion:@escaping (_ arr: [[String: AnyObject]])->()) {
        
        let urlString =  Domin + "/user/getmsglist"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        let tid = WBUserinfoManager.shared.userInfo.tid
        if tid != NULL {
            paramers["tid"] = tid as AnyObject
        }
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    print(arr)
                    completion(arr)
                }
            })
        }
    }

    //我的消息详情
    func requestMyMessageDetail(muid: Int,completion:@escaping (_ dic: [String: AnyObject])->()) {
        
        let urlString =  Domin + "/user/getmsginfo"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["muid"] = muid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(dic)
            })
        }
    }
    
    //阅读消息
    func requestMyMessageRead(muid: Int,completion:@escaping (_ dic: [String: AnyObject])->()) {
        
        let urlString =  Domin + "/user/setmsgread"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["muid"] = muid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(dic)
            })
        }
    }
    
    //删除消息
    func requestDeleteMyMessage(muid: Int,completion:@escaping (_ code: Int)->()) {
        
        let urlString =  Domin + "/user/deletemsg"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["muid"] = muid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code)
            })
        }
    }
    
    //我的收藏
    func requestMyCollect(completion:@escaping (_ arr: [[String: AnyObject]])->()) {
        
        let urlString =  Domin + "/user/garagecollect"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr)
                }else{
                    completion([])
                }
            })
        }
    }
 
    //删除我的收藏
    func requestDeleteMyCollect(gid: Int,completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/user/garagecancelcollect"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["gid"] = gid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            print("json: \(json)")
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //收藏修配信息
    func requestCollectRepair(gid: Int,completion:@escaping (_ isSuccess: Bool)->()) {
        let urlString =  Domin + "/garage/collect"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["gid"] = gid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //我发布的出租车需求信息列表
    func requestMyPublish(completion:@escaping (_ arr: [[String: AnyObject]])->()) {
        
        let urlString =  Domin + "/user/getdemandlist"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr)
                }
            })
        }
    }
    
    //我发布的汽修厂的信息
    func requestMyGarage(completion:@escaping (_ dic: [String: AnyObject])->()) {
        
        let urlString =  Domin + "/user/mygarage"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                
                print("mygarage:\(dic)")
                completion(dic)
            })
        }
    }
    
    //发布的汽修厂的信息
    func requestPublishGarage(parameters: [String: AnyObject], completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/garage/addgarage"
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: parameters) { (json, isSuccess) in
            print("json:\(json)")
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //编辑我发布的汽修厂的信息
    func requestEditMyGarage(parameters: [String: AnyObject], completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/user/editgarage"
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: parameters) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                
                print("editgarage:\(dic)")
                completion(code == 200)
            })
        }
    }
    
    //删除我发布的汽修厂的信息
    func requestDeleteMyGarage(gid: Int, completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/user/deletegarage"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["gid"] = gid as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //用户反馈
    func requestFeedback(text: String, completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/general/feedback"
        
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["text"] = text as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //首页横幅
    func requestAdBrannerList(completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/ad/getbanner"
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: nil) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr,true)
                    SVProgressHUD.dismiss()
                }
            })
        }
    }

    //首页列表
    func requestAdHomeList(completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/ad/getlist"
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: nil) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr,true)
                    SVProgressHUD.dismiss()
                }
            })
        }
    }
    
    //html页面
    func requestHtml(hid: String,completion:@escaping (_ text: String? ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/html5/gethtml?hid=" + hid
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: nil) { (json, isSuccess) in
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let text = dic["text"] as? String{
                    completion(text,true)
                    SVProgressHUD.dismiss()
                }
            })
        }
    }
    
    //公司列表
    func requestCompanyList(province: String, city: String,completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/getlist"
        
        var paramers = [String: AnyObject]();
        paramers["province"] = province as AnyObject;
        paramers["city"] = city as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                if let text = dic["text"] as? [[String: AnyObject]]{
                    completion(text,true)
                }
            })
        }
    }
    
    //加入公司
    func requestAddCompany( parameters: [String: AnyObject] ,completion:@escaping (_ code: Int)->()) {
        
        let urlString =  Domin + "/taxicompany/join"
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: parameters) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code)
            })
        }
    }
    
    //公司搜索
    func requestCompanySearchList(searchkey: String!,completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/search"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["searchkey"] = searchkey as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr,true)
                    SVProgressHUD.dismiss()
                }
            })
        }
        
    }
    
    //汽车修配列表
    func requestRepairList(city: String ,completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {

        let urlString =  Domin + "/garage/getlistbycity"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["city"] = city as AnyObject
        
        
        WBNetworkManager.shared.request(method: .POST ,URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr,true)
                }
            })
        }
    }
    
    //汽车修配 -- 搜索
    func requestRepairSearchList(searchkey: String!,completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/garage/search"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["searchkey"] = searchkey as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr,true)
                    SVProgressHUD.dismiss()
                }
            })
        }
    }
    
    
    //请求需求信息列表
    func requestNeedsList(type: Int = 1, city: String, completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/demand/getlist"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["type"] = type as AnyObject
        paramers["city"] = city as AnyObject
        
        print("paramers:\(paramers)")
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    print("arr:\(arr)")
                    completion(arr,true)
                    SVProgressHUD.dismiss()
                }
            })
        }
    }
    
    //发布我的需求
    func requestPublishNeeds(parameters: [String: AnyObject],isEdit: Bool, completion:@escaping (_ isSuccess: Bool)->()) {
        
        var urlString =  Domin + "/demand/postinfo"
        if isEdit {
            urlString = Domin + "/user/editdemand"
        }
        
        print("parameters:\(parameters)")
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: parameters) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //删除我发布的需求
    func requestDeleteMyNeeds(did: Int?, completion:@escaping (_ isSuccess: Bool)->()) {
        
        SVProgressHUD.show()
        
        let urlString =  Domin + "/user/deletedemand"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["did"] = did as AnyObject
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    //请求公司logo
    func requestCompanyLogo(completion:@escaping (_ dic: [String: AnyObject] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/info"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["tid"] = WBUserinfoManager.shared.userInfo.tid as AnyObject
        
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                completion(dic,true)
            })
        }
    }
    
    //请求公司信息
    func requestCompanyNotifList(type: String!,completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/" + type
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["tid"] = WBUserinfoManager.shared.userInfo.tid as AnyObject
        
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            if isSuccess{
                self.dealJson(json: json, completion: { (dic, code) in
                    if let arr = dic["text"] as? [[String: AnyObject]]{
                        completion(arr,true)
                    }
                })
            }else{
                completion([],false)
            }
        }
    }
    
    //请求咨询列表
    func requestConsultList(completion:@escaping (_ arr: [[String: AnyObject]] ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/consultationlist"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["tid"] = WBUserinfoManager.shared.userInfo.tid as AnyObject
        print(paramers)
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                if let arr = dic["text"] as? [[String: AnyObject]]{
                    completion(arr,true)
                }
            })
        }
    }
    
    //请求咨询详情
    func requestConsultDetail(cid: Int!,completion:@escaping (_ dic: [String: AnyObject]  ,_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/getconsult"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["cid"] = cid as AnyObject
        
        
        WBNetworkManager.shared.request(URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                completion(dic,true)
            })
        }
    }
    
    //发布咨询
    func requestPublishConsult(title: String!,content: String!,completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/postconsult"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["tid"] = WBUserinfoManager.shared.userInfo.tid as AnyObject
        paramers["title"] = title as AnyObject
        paramers["content"] = content as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
                self.dealJson(json: json, completion: { (dic, code) in
                    completion(code == 200)
                })
        }
    }
    
    //删除咨询
    func requestDeleteConsult(cid: Int!,completion:@escaping (_ isSuccess: Bool)->()) {
        
        let urlString =  Domin + "/taxicompany/deleteconsult"
        var paramers = [String: AnyObject]();
        paramers["uid"] = WBUserinfoManager.shared.userInfo.uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.userInfo.sec as AnyObject
        paramers["cid"] = WBUserinfoManager.shared.userInfo.tid as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            self.dealJson(json: json, completion: { (dic, code) in
                completion(code == 200)
            })
        }
    }
    
    
    //或者经纬度
    func requestAddressCode(address: String,completion:@escaping (_ dic: [String: AnyObject])->()) {
        
//        let str = "http://api.map.baidu.com/geocoder/v2/?address="+address+"&output=json&ak=o6M4IyvloAjPmNUKhSyKGWpS1TItE0oE"
//        let urlString =  Tool.encodeUTF8(str)
        
        let urlString =  "http://api.map.baidu.com/geocoder/v2/"
        var paramers = [String: AnyObject]();
        paramers["address"] = address as AnyObject
        paramers["output"] = "json" as AnyObject
        paramers["ak"] = "o6M4IyvloAjPmNUKhSyKGWpS1TItE0oE" as AnyObject
        
        WBNetworkManager.shared.request(method: .POST, URLString: urlString, parameters: paramers) { (json, isSuccess) in
            
            print("xxxxx:",json);
            
            self.dealJson(json: json, completion: { (dic, code) in
                if let location = dic["result"]?["location"] as? [String: AnyObject]{
                    completion(location)
                }
            })
        }
    }
    
    
    
    func dealJson(json: Any?,completion:@escaping (_ dic: [String: AnyObject] ,_ code: Int)->()) {
        
        guard let dic = json as? [String: AnyObject]
            else{
                SVProgressHUD.showError(withStatus: "请求失败")
                return
        }
        
        let codeStr = dic["code"] as? String ?? "400"
        let code = Int(codeStr) ?? 400
        completion(dic, code)
    }
}
