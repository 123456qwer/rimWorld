//
//  UIView+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit

extension UIView {
    /// 获取有效的安全区域（已布局）
    var safeAreaTop: CGFloat {
        layoutIfNeeded()
        return safeAreaInsets.top
    }

    var safeAreaBottom: CGFloat {
        layoutIfNeeded()
        return safeAreaInsets.bottom
    }
    
    /// 顺序添加多个子视图
    /// - Parameter views: 视图数组
    public func ml_addSubviews(_ views: [UIView]) {
        views.forEach { subview in
            self.addSubview(subview)
        }
    }
}
