//
//  UIScreen+Extenions.swift
//  SwiftWeibo
//
//  Created by ling on 2017/6/30.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit


extension UIScreen {
    
    func get_ScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func get_ScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}
