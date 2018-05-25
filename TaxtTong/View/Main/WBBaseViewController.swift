//
//  WBBaseViewController.swift
//  SwiftWeibo
//
//  Created by ling on 2017/6/28.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController {
    
    //自定义导航栏
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen().get_ScreenWidth(), height: 64))
    lazy var navItem = UINavigationItem()
    
    override var title: String? {
        didSet {
            navItem.title = title ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        setupUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension WBBaseViewController {
    
    func setupUI() {
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        //中间标题颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //两侧按钮文字颜色
        navigationBar.tintColor = UIColor.white
        //导航栏背景色
        navigationBar.barTintColor = UIColor().getMainColor()
    }
}
