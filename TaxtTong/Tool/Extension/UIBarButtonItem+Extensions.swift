//
//  UIBarButtonItem+Extensions.swift
//  SwiftWeibo
//
//  Created by ling on 2017/6/30.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    //便利构造函数
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector ,isBack : Bool = false) {
        
        
        let btn = UIButton.init(title: title, fontSize:16 ,normalColor: UIColor.white, highlightColor: UIColor().getTransColor())
        btn.addTarget(target, action: action, for: .touchUpInside)
        
//        if isBack {
//            let imageName = "xx"
//            btn.setImage(UIImage(named: imageName), for: .normal)
//            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
//            btn.sizeToFit()
//        }
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
}
