//
//  WBMainViewController.swift
//  SwiftWeibo
//
//  Created by ling on 2017/6/28.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {

    //MARK: 懒加载
    lazy var composeButton: UIButton = UIButton.init(imageName: "tabbar_compose_icon_add", backImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait //portrait - 竖屏 landscape - 横屏
    }
    
       
    func composeStatus() {
        print("center")
    }
}


//extension相当于OC的分类，在swift中还可以切分代码块，把相近的功能函数，放在extesnion内
//和OC分类一样，extension不能定义属性
extension WBMainViewController {
    
    //设置所有字控制器
     func setupChildControllers(){
        
        var array = [
            ["clsName":"WBHomeViewController","title":"主页","imageName":"shouye"],
            ["clsName":"WBProfileViewController","title":"我","imageName":"wo"],
            ["clsName":"WBMessageViewController","title":"需求信息","imageName":"xinxixuqiun"],
            ["clsName":"RepairViewController","title":"汽车修配","imageName":"qichexiupei"],
        ]
        
        let tid = WBUserinfoManager.shared.userInfo.tid
        let companystate = WBUserinfoManager.shared.userInfo.companystate
        print("companystatecompanystatecompanystate:\(companystate)")
        if tid != nil && tid != NULL && companystate == 2 {
            array.insert(["clsName":"WBCompanyViewController","title":"公司","imageName":"gongsi"], at: 1)
        }else{
            array.insert(["clsName":"WBAddCompanyController","title":"公司","imageName":"gongsi"], at: 1)
        }
        
        
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
        
    }
    
    private func controller(dict: [String:String]) -> UIViewController {
        
        guard let clsName = dict["clsName"],
              let title = dict["title"],
              let imageName = dict["imageName"],
              let cls = NSClassFromString(Bundle.main.nameSpace() + "." + clsName) as? UIViewController.Type
        else {
            return UIViewController()
        }

        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_highlighted")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().getMainColor()], for: .highlighted)
        
        let nav = WBNavigatorController(rootViewController: vc)
        
        return nav
        
        
    }
}
