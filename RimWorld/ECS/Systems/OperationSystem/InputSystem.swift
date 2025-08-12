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


typealias TouchHandler = (CGPoint, BaseScene) -> Void


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
    
   
    
    // 触摸按下映射
    lazy var touchDownHandlers: [GameMode: TouchHandler] = [
        .normal: normalTouchdown,
        .storage: areaSelectTouchdown,
        .build: buildTouchdown,
        .deconstruct: deconstructTouchdown,
        .growing: growingTouchdown,
        .cancel: cancelTouchdown,
        .cutting: cuttingTouchdown,
        .mining: miningTouchdown,
    ]
    
    // 触摸移动映射
    lazy var touchMovedHandlers: [GameMode: TouchHandler] = [
        .normal: normalTouchMoved,
        .storage: areaSelectTouchMoved,
        .build: buildTouchMoved,
        .deconstruct: deconstructTouchMoved,
        .growing: growingTouchMoved,
        .cancel: cancelTouchMoved,
        .cutting: cuttingTouchMoved,
        .mining: miningTouchMoved,
    ]
    
    // 触摸抬起映射
    lazy var touchUpHandlers: [GameMode: TouchHandler] = [
        .normal: normalTouchUp,
        .storage: areaSelectTouchUp,
        .build: buildTouchUp,
        .deconstruct: deconstructTouchUp,
        .growing: growingTouchUp,
        .cancel: cancelTouchUp,
        .cutting: cuttingTouchUp,
        .mining: miningTouchUp,
    ]
    
    
    init (ecsManager: ECSManager,
          gameContext: RMGameContext,
          areaProvider: AreaSelectProvider) {
        self.ecsManager = ecsManager
        self.gameContext = gameContext
        self.areaProvider = areaProvider
    }
    
    func touchDown(atPoint pos : CGPoint, scene:BaseScene) {
        touchDownHandlers[gameContext.currentMode]?(pos, scene)
    }
    
    func touchMoved(toPoint pos : CGPoint, scene:BaseScene) {
        touchMovedHandlers[gameContext.currentMode]?(pos, scene)
    }
    
    func touchUp(atPoint pos: CGPoint, scene: BaseScene) {
        touchUpHandlers[gameContext.currentMode]?(pos, scene)
    }
    

}









