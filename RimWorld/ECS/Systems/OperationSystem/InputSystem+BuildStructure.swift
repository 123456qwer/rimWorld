//
//  InputSystem+Build.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import SpriteKit

/// 建造模式
extension InputSystem {
    
    /// 按下
    func buildStructureTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
    }
   
    /// 滑动
    func buildStructureTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        
        isTouchMoved = true

        createBluePrint(atPoint: pos, scene: scene)
    }
    
    
    /// 抬起
    func buildStructureTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
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
        let woodCount = 30
        let blueprintType = BlueprintType.wall
        
        // TODO: - 这里先简单设置为woodWall,实际应该根据类型 -
        
        let params = BlueprintParams(
            size: CGSizeMake(tileSize, tileSize),
            materials: ["\(wood)":woodCount],
            type: blueprintType,
            totalBuildPoint: 100,
            textureName: "woodWall"
        )
        
        /// 创建蓝图
        RMEventBus.shared.requestCreateEntity(type: kBlueprint,
                                              point: converPoint,
                                              params: params)
        
    }
}
