//
//  InputSystem+AreaSelect.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import SpriteKit

/// 存储区域选择模式
extension InputSystem {
    
    /// 按下
    func areaSelectTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
        selectNode.removeFromParent()
        selectNode = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
        selectNode.anchorPoint = CGPoint(x: 0, y: 0)
        selectNode.zPosition = 100000
        selectNode.position = pos
        scene.addChild(selectNode)
    }
    
    /// 滑动
    func areaSelectTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        
        
        let xChange = pos.x - lastTouchLocation.x
        let yChange = pos.y - lastTouchLocation.y
        
        selectNode.xScale = xChange / 1
        selectNode.yScale = yChange / 1
        selectNode.alpha = 0.2
        print(xChange,yChange,selectNode)
    }
    
    /// 抬起
    func areaSelectTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        
        areaProvider.selectArea(start: lastTouchLocation,
                                end: pos,
                                size: selectNode.size,
                                areaNode: selectNode)
    }
    
}
