//
//  InputSystem+Build.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import SpriteKit

struct TilePoint: Hashable {
    let x: Int
    let y: Int
}

/// Normal模式
extension InputSystem {
    
    /// 按下
    func buildTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
    }
   
    /// 滑动
    func buildTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        
        isTouchMoved = true

        createBluePrint(atPoint: pos, scene: scene)
    }
    
    
    /// 抬起
    func buildTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        if isTouchMoved {
            isTouchMoved = false
            return
        }
        
        createBluePrint(atPoint: pos, scene: scene)
    }
    
    
    
    private func createBluePrint(atPoint pos: CGPoint, scene: BaseScene){
        let converPoint = scene.converPointForTile(point: pos)
        let key = TilePoint(x: Int(converPoint.x), y: Int(converPoint.y))
        let blueprintNodes = ecsManager.entitiesAbleToBeBuild()
        if blueprintNodes[key] != nil {
            return
        }
        
        /// 创建蓝图
        ecsManager.createEntity(kBlueprint, converPoint, CGSizeMake(tileSize, tileSize), ["material":MaterialType.wood])
    }
}
