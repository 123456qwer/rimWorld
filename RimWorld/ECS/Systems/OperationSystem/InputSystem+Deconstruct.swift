//
//  InputSystem+Deconstruct.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import SpriteKit


extension InputSystem {
    
    /// 按下
    func deconstructTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
      
    }
   
    /// 滑动
    func deconstructTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        isTouchMoved = true
        removeBuild(atPoint: pos, scene: scene)
    }
    
    /// 抬起
    func deconstructTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        if isTouchMoved {
            isTouchMoved = false
            return
        }
        
        removeBuild(atPoint: pos, scene: scene)
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()

    }
    
    
    private func removeBuild(atPoint pos: CGPoint, scene: BaseScene) {
        let converPoint = scene.converPointForTile(point: pos)
        let key = TilePoint(x: Int(converPoint.x), y: Int(converPoint.y))
        let blueprintNodes = ecsManager.entitiesAbleToBeBuild()
        guard let entity = blueprintNodes[key] else {
            return
        }
        
        /// 移除
        RMEventBus.shared.requestRemoveEntity(entity)
    }
}
