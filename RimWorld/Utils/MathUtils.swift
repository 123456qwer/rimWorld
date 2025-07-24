//
//  Math.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import Foundation
import UIKit

enum MathUtils {
    /// 距离
    static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat{
        return hypot(b.x - a.x, b.y - a.y)
    }
    
    /// 角度转弧度
    static func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return angle / 180.0 * CGFloat.pi
    }

    /// 弧度转角度
    static func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
        return radians * (180.0 / CGFloat.pi)
    }
    
    /// 文字宽度
    static func textWidth(_ text: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        ).size
        return ceil(size.width)
    }
}
