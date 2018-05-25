//
//  Bundle+Extensions.swift
//  SwiftWeibo
//
//  Created by ling on 2017/6/28.
//  Copyright © 2017年 ling. All rights reserved.
//

import Foundation

extension Bundle {
    
    //返回命名空间
    func nameSpace() -> String {
        return Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }
}

