//
//  WBNavigatorController.swift
//  SwiftWeibo
//
//  Created by ling on 2017/6/28.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBNavigatorController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
//        navigationBar.isHidden = true
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationBar.barTintColor = UIColor().getMainColor()
        navigationBar.tintColor = UIColor.white
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? WBBaseViewController {
                
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: "返回",target: self, action: #selector(popToParent), isBack: true)
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    
    @objc private func popToParent(){
        popViewController(animated: true)
    }
    
}
