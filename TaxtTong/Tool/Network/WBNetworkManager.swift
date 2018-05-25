//
//  WBNetworkManager.swift
//  TaxtTong
//
//  Created by ling on 2017/7/3.
//  Copyright © 2017年 ling. All rights reserved.
//

import AFNetworking
import SVProgressHUD

enum WBHTTPMethod {
    case GET
    case POST
}

class WBNetworkManager: AFHTTPSessionManager {
    
    //单例
    static let shared: WBNetworkManager = {
        
        let instance = WBNetworkManager()
        
        //设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
    
    //@escaping -- 逃逸闭包
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion:@escaping (_ json: Any?, _ isSuccess: Bool)->()){
        
        let success = { (task: URLSessionDataTask, json: Any?)->() in
            completion(json, true);
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
            print("err:\(error)")
            SVProgressHUD.dismiss()
            completion(nil, false);
        }
        
        
        if method == .GET{
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
