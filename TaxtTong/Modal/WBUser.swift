//
//  WBUser.swift
//  TaxtTong
//
//  Created by ling on 2017/7/9.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import HandyJSON

class WBUser: HandyJSON {

    var uid: Int64 = 0
    
    var companystate: Int64 = 0
    
    var name: String?
    
    var platenumber: String?

    var nickname: String?
    
    var himg: String?
 
    var tid: String?
    
    var phone: String?
    
    var sec: String?
    
    var credentials: String?
    
    var linkphone: String?

    var gid: Int = 0
    
    required init() {}
    
}
