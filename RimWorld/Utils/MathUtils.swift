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
    
    /// 文字高度
    static func textHeight(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        ).size
        return ceil(size.height)
    }
    
    /// 九宫格
    static func getSurroundingPoints(center: CGPoint, distance: CGFloat = 32) -> [CGPoint] {
        var points: [CGPoint] = []
        
        for dy in [-1, 0, 1] {
            for dx in [-1, 0, 1] {
                if dx == 0 && dy == 0 { continue } // 跳过中心点
                let point = CGPoint(x: center.x + CGFloat(dx) * distance,
                                    y: center.y + CGFloat(dy) * distance)
                points.append(point)
            }
        }
        
        return points
    }
}
