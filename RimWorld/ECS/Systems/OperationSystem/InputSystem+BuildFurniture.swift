//
//  Input+BuildFurniture.swift
//  RimWorld
//
//  Created by wu on 2025/8/14.
//

import Foundation
import SpriteKit

/// 建造模式
extension InputSystem {
    
    /// 按下
    func buildFurnitureTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        lastTouchLocation = provider.converPointForTile(point: pos)
        
        if gameContext.currentMode == .fueledStove {
            
            selectNode.removeFromParent()
            selectNode = SKSpriteNode(texture: TextureManager.shared.getTexture("stove"), size: CGSize(width: tileSize * 2.0, height: tileSize))
            selectNode.anchorPoint = CGPoint(x: 0.25, y: 0.5)
            selectNode.zPosition = 100000
            selectNode.position = lastTouchLocation
            selectNode.alpha = 0.5
            scene.addChild(selectNode)
            
        }
    }
   
    /// 滑动
    func buildFurnitureTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        
        isTouchMoved = true
        
        lastTouchLocation = provider.converPointForTile(point: pos)
        selectNode.position = lastTouchLocation
        

    }
    
    
    /// 抬起
    func buildFurnitureTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
//        if isTouchMoved {
//            isTouchMoved = false
//            return
//        }
        
        lastTouchLocation = pos
        lastTouchLocation = provider.converPointForTile(point: pos)
        
        selectNode.position = CGPoint(x: lastTouchLocation.x , y: lastTouchLocation.y)
        
        createBluePrint(atPoint: pos, scene: scene)

    }
    
    private func createBluePrint(atPoint pos: CGPoint,
                                 scene: BaseScene){
        
        let converPoint = scene.converPointForTile(point: pos)
        let key = TilePoint(x: Int(converPoint.x), y: Int(converPoint.y))
        let blueprintNodes = ecsManager.entitiesAbleToBeBuild()
        if blueprintNodes[key] != nil {
            return
        }
        
        /// 这里的参数需要玩家自己设置的
        let wood = MaterialType.wood.rawValue
        let woodCount = 10
         
        let marble = MaterialType.marble.rawValue
        let marbleCount = 3
        
        let blueprintType = BlueprintType.stove
        
        let params = BlueprintParams(
            size: CGSizeMake(tileSize * 2.0, tileSize),
            materials: ["\(wood)":woodCount,"\(marble)":marbleCount],
            type: blueprintType,
            totalBuildPoint: 100,
            textureName: "stove",
            anchorPoint: selectNode.anchorPoint
        )

        /// 创建蓝图
        RMEventBus.shared.requestCreateEntity(type: kBlueprint,
                                              point: selectNode.position,
                                              params: params)
        selectNode.removeFromParent()

    }
    

}
