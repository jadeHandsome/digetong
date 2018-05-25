//
//  UIAlertController+Extension.swift
//  TaxtTong
//
//  Created by ling on 2017/8/23.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    //初始化
    func share(target: UIViewController!, msg:String!, completion:@escaping ()->()) {
        
        
        let alertController = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive) { (action) in
            completion()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        target.present(alertController, animated: true, completion: nil)

    }
}

