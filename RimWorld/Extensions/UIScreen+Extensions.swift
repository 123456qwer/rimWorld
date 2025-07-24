//
//  UIScreen+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit

extension UIScreen {
    /// 屏幕宽度
    static let screenWidth = UIScreen.main.bounds.size.width

    /// 屏幕高度
    static let screenHeight = UIScreen.main.bounds.size.height

    /// scale
    static let screenScale = UIScreen.main.scale

    /// 是否是异形屏
    static let isSpecial = (screenHeight - BT_HEIGHT_OF_IPHONE_X) >= -1e-5

    /// 底部安全区
    static var safeBottom: CGFloat {
        return 21.0
    }
    
    /// 左边安全区
    static var safeLeft: CGFloat {
        return 34.0
    }

    /// 导航栏高度
    static var navibarHeight: CGFloat {
        return UIApplication.ml_statusBarHeight + 44.0
    }

    /// 底部 tab 高度
    static var tabbarHeight: CGFloat {
        screenHeight >= BT_HEIGHT_OF_IPHONE_X ? 83.0 : 49.0
    }

    static let BT_HEIGHT_OF_IPHONE_X: CGFloat = 812.0

}
