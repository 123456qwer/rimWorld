//
//  UIColor+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    /// 十六进制 Int 颜色 转 UIColor
    /// - Parameters:
    ///   - hexValue: 16进制 Int 颜色 eg. 0x999999
    ///   - alpha: 透明度 默认 1.0
    /// - Returns: UIColor
    static func ml_color(hexValue: Int, alpha: CGFloat = 1.0) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hexValue & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hexValue & 0x0000FF       ) / divisor
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 展示界面的默认背景色
    static func BgColor() -> UIColor {
        return UIColor.ml_color(hexValue: 0x3c3c4b)
    }
    
    /// 按钮背景色
    static func btnBgColor() -> UIColor {
        return UIColor.ml_color(hexValue: 0x5c5d6b)
    }
}
