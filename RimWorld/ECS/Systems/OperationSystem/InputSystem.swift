//
//  InputSystem.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import Foundation
import SpriteKit

/// 区域选择
protocol AreaSelectProvider {
    func selectArea(start: CGPoint,
                    end: CGPoint,
                    size:CGSize,
                    areaNode:SKSpriteNode)
}


class InputSystem: System {

    /// 最大可移动范围
    var xPage:CGFloat = 160 * tileSize / 2.0 - UIScreen.screenWidth / 2.0
    var yPage:CGFloat = 120 * tileSize / 2.0 - UIScreen.screenHeight / 2.0
    
    
    var lastTouchLocation:CGPoint = CGPoint(x: 0, y: 0)
    
    var isTouchMoved:Bool = false
    var isTouchBegin:Bool = false
    
    var selectNode:SKSpriteNode = SKSpriteNode()

    let ecsManager: ECSManager
    let gameContext: RMGameContext
    let areaProvider: AreaSelectProvider
    
   
    
    init (ecsManager: ECSManager,
          gameContext: RMGameContext,
          areaProvider: AreaSelectProvider) {
        self.ecsManager = ecsManager
        self.gameContext = gameContext
        self.areaProvider = areaProvider
    }
    
    func touchDown(atPoint pos : CGPoint, scene:BaseScene) {

//        ECSLogger.log("点下操作：\(pos)")
        
        switch gameContext.currentMode {
        case .normal:
            normalTouchdown(atPoint: pos, scene: scene)
        case .storage:
            areaSelectTouchdown(atPoint: pos, scene: scene)
        case .build:
            buildTouchdown(atPoint: pos, scene: scene)
        case .deconstruct:
            deconstructTouchdown(atPoint: pos, scene: scene)
        case .growing:
            growingTouchdown(atPoint: pos, scene: scene)
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint, scene:BaseScene) {

        switch gameContext.currentMode {
        case .normal:
            normalTouchMoved(atPoint: pos, scene: scene)
        case .storage:
            areaSelectTouchMoved(atPoint: pos, scene: scene)
        case .build:
            buildTouchMoved(atPoint: pos, scene: scene)
        case .deconstruct:
            deconstructTouchMoved(atPoint: pos, scene: scene)
        case .growing:
            growingTouchMoved(atPoint: pos, scene: scene)
        }
    }
    
    func touchUp(atPoint pos: CGPoint, scene: BaseScene, entities: [RMEntity]) {
        
//        ECSLogger.log("抬起操作：\(pos)")

        switch gameContext.currentMode {
        case .normal:
            normalTouchUp(atPoint: pos, scene: scene)
        case .storage:
            areaSelectTouchUp(atPoint: pos, scene: scene)
        case .build:
            buildTouchUp(atPoint: pos, scene: scene)
        case .deconstruct:
            deconstructTouchUp(atPoint: pos, scene: scene)
        case .growing:
            growingTouchUp(atPoint: pos, scene: scene)
        }

    }
    
 
}









