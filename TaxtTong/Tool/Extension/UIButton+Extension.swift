//
//  UIButton+Extension.swift
//  Weibo10
//
//  Created by male on 15/10/14.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

extension UIButton {
    
    //便利构造函数
    convenience init(imageName: String, backImageName: String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: .highlighted)
        
        sizeToFit()
    }
    
    
    convenience init(title: String, fontSize: CGFloat , normalColor: UIColor, highlightColor: UIColor) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(normalColor, for: .normal)
        setTitleColor(highlightColor, for: .highlighted)
        
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    func makeRadius(target: UIButton,borderRadius: CGFloat,backgroudColor: UIColor = UIColor().getMainColor(),text: String,textColor: UIColor = UIColor.white, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear  ) -> UIButton {
        
        target.layer.borderWidth = borderWidth
        target.layer.borderColor = borderColor.cgColor
        target.layer.cornerRadius = borderRadius
        target.layer.masksToBounds = true
        target.backgroundColor = backgroudColor
        target.setTitle(text, for: .normal)
        target.setTitleColor(textColor, for: .normal)
        
        return target
    }
    
    func makeRadius(target: UIButton,borderRadius: CGFloat,backgroudColor: UIColor,text: String,textColor: UIColor = UIColor.white ) -> UIButton {
        
        target.layer.cornerRadius = borderRadius
        target.layer.masksToBounds = true
        target.backgroundColor = backgroudColor
        target.setTitle(text, for: .normal)
        target.setTitleColor(textColor, for: .normal)
        
        return target
    }
    
}
