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
        
        /// 这里的参数需要玩家自己设置的
        let wood = MaterialType.wood.rawValue
        let woodCount = 10
        let blueprintType = BlueprintType.wall
        
        let params = BlueprintParams(
            size: CGSizeMake(tileSize, tileSize),
            materials: ["\(wood)":woodCount],
            type: blueprintType,
            totalBuildPoint: 1000
        )
        
        /// 创建蓝图
        RMEventBus.shared.requestCreateEntity(type: kBlueprint,
                                              point: converPoint,
                                              params: params)
        
    }
}
