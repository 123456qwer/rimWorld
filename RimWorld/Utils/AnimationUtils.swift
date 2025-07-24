//
//  AnimationUtils.swift
//  RimWorld
//
//  Created by wu on 2025/6/9.
//

import Foundation
import SpriteKit

enum AnimationUtils {
    
    /// 旋转动画(重复)
    static func rotateActionRep(withDegreesArr rotateArr: [CGFloat], timeArr: [CGFloat]) -> SKAction {
           
        var actions = [SKAction]()
            
        for i in 0..<rotateArr.count {
            let time = TimeInterval(timeArr[i])
            let degrees = MathUtils.degreesToRadians(rotateArr[i])
            let rotateAction = SKAction.rotate(toAngle: degrees, duration: time)
            actions.append(rotateAction)
        }
        
        let sequence = SKAction.sequence(actions)
        return SKAction.repeatForever(sequence)
    }


    /// 旋转动画
    static func rotateAction(withDegreesArr rotateArr: [CGFloat], timeArr: [CGFloat]) -> SKAction {
           
        var actions = [SKAction]()
            
        for i in 0..<rotateArr.count {
            let time = TimeInterval(timeArr[i])
            let degrees = MathUtils.degreesToRadians(rotateArr[i])
            let rotateAction = SKAction.rotate(toAngle: degrees, duration: time)
            actions.append(rotateAction)
        }
        
        let sequence = SKAction.sequence(actions)
        return sequence
    }
}
