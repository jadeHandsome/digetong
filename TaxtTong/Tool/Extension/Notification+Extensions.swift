//
//  NotificationCenter+Extensions.swift
//  TaxtTong
//
//  Created by ling on 2017/7/6.
//  Copyright © 2017年 ling. All rights reserved.
//

import Foundation

extension NotificationCenter {
    
    func post(name: String, dict: [AnyHashable : Any]?) {
        
        let notificationName = Notification.Name(rawValue: name)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: dict)
    }

    
    func addObserve(target: Any, selector: Selector, name: String) {
        
        let notificationName = Notification.Name(rawValue: name)
        NotificationCenter.default.addObserver(target, selector: selector, name: notificationName, object: nil)
        
    }
    

}
