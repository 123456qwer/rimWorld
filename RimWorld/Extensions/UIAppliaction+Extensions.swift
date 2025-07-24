//
//  UIAppliaction+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit


/// 语言
func textAction(_ key:String) -> String{
    return NSLocalizedString(key, comment: "")
}


extension UIApplication {
    
    /// Getting keyWindow
    public static var ml_keyWindow: UIWindow? {
        
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
        
    }
    
    /// 状态栏高度
    public static var ml_statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        
        if #available(iOS 13.0, *) {
            //此时可能还没有 keyWindow
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let statusBarManager = windowScene.statusBarManager {
                statusBarHeight = statusBarManager.statusBarFrame.height
            }
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }

        return statusBarHeight
    }
    
    /// navigationBar 的静态高度
    public static var ml_navigationBarHeight: CGFloat {
        //待完善横竖屏&iPad
        return CGFloat(44)
    }
    
    
    /// 代表(导航栏+状态栏)，这里用于获取其高度
    public static var ml_navigationContentTop: CGFloat {
        return self.ml_statusBarHeight + self.ml_navigationBarHeight
    }
}

extension DispatchQueue {
    public static func runOnMain(_ task: @escaping () -> Void) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }
    
    public static func after(_ time: TimeInterval, block: @escaping ()-> ()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: block)
    }
}
