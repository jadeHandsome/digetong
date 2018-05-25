//
//  UIColor+Extensions.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

extension UIColor {
    
    //全局颜色
    func getMainColor() -> UIColor {
        return getRGB(r: 25, g: 128, b: 209)
    }
    
    //半透明白色
    func getTransColor() -> UIColor {
        return getRGBA(r: 255, g: 255, b: 255, a: 0.3)
    }
    
    func getRGB(r: Float,g: Float,b: Float) -> UIColor {
        return UIColor(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    func getRGBA(r: Float,g: Float,b: Float,a: Float = 1.0) -> UIColor {
        return UIColor(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    func rgbaColorFromHex(rgb:Int) ->UIColor {
        return getRGB(r: Float((CGFloat)((rgb & 0xFF0000) >> 16)), g: Float((CGFloat)((rgb & 0xFF00) >> 8)), b: Float((CGFloat)(rgb & 0xFF)))
    }
}
