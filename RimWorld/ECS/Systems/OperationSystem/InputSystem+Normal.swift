//
//  InputSystem+Normal.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import SpriteKit

/// Normal模式
extension InputSystem {
    
    /// 按下
    func normalTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
      
    }
   
    /// 滑动
    func normalTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        isTouchMoved = true
        
        let lastLocation = lastTouchLocation
        let currentLocation = pos
        let camera = scene.cameraNode
        
        let delta = CGPoint(x: lastLocation.x - currentLocation.x,
                            y: lastLocation.y - currentLocation.y)
        let cameraPosition = CGPoint(x: camera.position.x + delta.x, y: camera.position.y + delta.y)
        
        var x = cameraPosition.x
        var y = cameraPosition.y
        
        if x > xPage{
            x = xPage
        }else if x < -xPage{
            x = -xPage
        }
        
        if y > yPage {
            y = yPage
        }else if y < -yPage {
            y = -yPage
        }
        
        scene.cameraNode.position = CGPoint(x: x, y: y)
    }
    
    /// 抬起
    func normalTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        if isTouchMoved {
            isTouchMoved = false
            return
        }
        
        let nodes = scene.nodes(at: pos)
        
        var nearNode: SKNode? = nil
        var maxZNode: SKNode? = nil
        
        for node in nodes {
            
            if let rmNode = node as? RMBaseNode {
                let distance = MathUtils.distance(node.position, pos)
                
                // 如果没有设置最接近的节点，直接设定
                if nearNode == nil || distance < MathUtils.distance(nearNode!.position, pos) {
                    nearNode = node
                }
                
                // 如果没有设置最大的Z值节点，或者当前节点的Z值更大
                if maxZNode == nil || node.zPosition > maxZNode!.zPosition {
                    maxZNode = node
                }
                
                /*
                /// 被持有的node先简单忽略处理
                if (rmNode.rmEntity?.getComponent(ofType: OwnedComponent.self)) != nil {
                    continue
                }
                 */
                
                // 点击node
                RMEventBus.shared.requestClickEntity(rmNode.rmEntity ?? RMEntity(), nodes)
                
                return
            }
        }
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()

    }
}
