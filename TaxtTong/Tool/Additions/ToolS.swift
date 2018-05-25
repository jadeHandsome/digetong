//
//  ToolS.swift
//  TaxtTong
//
//  Created by ling on 2017/8/25.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class ToolS: UIViewController {
    
    //单例
    static let shared: ToolS = {
        
        let instance = ToolS()
        
        return instance
    }()
    
    func checkOutTabbar(vc: WBBaseViewController){
        
        vc.title = "公司"
        vc.tabBarItem.image = UIImage(named: "tabbar_gongsi")
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_gongsi_highlighted")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().getMainColor()], for: .highlighted)
        let nav = WBNavigatorController(rootViewController: vc)
        var vcArr = self.tabBarController?.viewControllers
        vcArr?.replaceSubrange(Range(1..<2), with: [nav])
        self.tabBarController?.setViewControllers(vcArr, animated: true)
    }
    
}
