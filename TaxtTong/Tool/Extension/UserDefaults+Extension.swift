//
//  UserDefaults+Extension.swift
//  TaxtTong
//
//  Created by ling on 2017/7/4.
//  Copyright © 2017年 ling. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func saveUserDefaults(key: String,value: Any?){
        let userDefatluts = UserDefaults.standard
        userDefatluts.set(value ?? "", forKey: key)
        userDefatluts.synchronize()
    }
    
    func getUserDefaults(key: String) -> Any?{
        return UserDefaults.standard.object(forKey: key)
    }
}
