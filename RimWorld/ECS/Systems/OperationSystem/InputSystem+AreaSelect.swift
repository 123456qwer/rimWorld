//
//  InputSystem+AreaSelect.swift
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

    }
    
    /// 抬起
    func areaSelectTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        
        areaProvider.selectArea(start: lastTouchLocation,
                                end: pos,
                                size: selectNode.size,
                                areaNode: selectNode)
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
    }
    
}



/// 种植区域选择模式
extension InputSystem {
    
    /// 按下
    func growingTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
        selectNode.removeFromParent()
        selectNode = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
        selectNode.anchorPoint = CGPoint(x: 0, y: 0)
        selectNode.zPosition = 100000
        selectNode.position = pos
        scene.addChild(selectNode)
    }
   
    /// 滑动
    func growingTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        
        let xChange = pos.x - lastTouchLocation.x
        let yChange = pos.y - lastTouchLocation.y
        
        selectNode.xScale = xChange / 1
        selectNode.yScale = yChange / 1
        selectNode.alpha = 0.2
    }
    
    /// 抬起
    func growingTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        
        areaProvider.selectArea(start: lastTouchLocation,
                                end: pos,
                                size: selectNode.size,
                                areaNode: selectNode)
        

        /// 点击空白
        RMEventBus.shared.requestClickEmpty()

    }
}



/// 取消操作区域选择
extension InputSystem {
    
    /// 按下
    func cancelTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
        selectNode.removeFromParent()
        selectNode = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
        selectNode.anchorPoint = CGPoint(x: 0, y: 0)
        selectNode.zPosition = 100000
        selectNode.position = pos
        scene.addChild(selectNode)
    }
   
    /// 滑动
    func cancelTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        let xChange = pos.x - lastTouchLocation.x
        let yChange = pos.y - lastTouchLocation.y
        
        selectNode.xScale = xChange / 1
        selectNode.yScale = yChange / 1
        selectNode.alpha = 0.2
    
    }
    
    /// 抬起
    func cancelTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        
        areaProvider.selectArea(start: lastTouchLocation,
                                end: pos,
                                size: selectNode.size,
                                areaNode: selectNode)
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
    }
    
}


/// 割除操作区域选择
extension InputSystem {
    
    /// 按下
    func cuttingTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
        selectNode.removeFromParent()
        selectNode = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
        selectNode.anchorPoint = CGPoint(x: 0, y: 0)
        selectNode.zPosition = 100000
        selectNode.position = pos
        scene.addChild(selectNode)
    }
   
    /// 滑动
    func cuttingTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        let xChange = pos.x - lastTouchLocation.x
        let yChange = pos.y - lastTouchLocation.y
        
        selectNode.xScale = xChange / 1
        selectNode.yScale = yChange / 1
        selectNode.alpha = 0.2
    
    }
    
    /// 抬起
    func cuttingTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        
        areaProvider.selectArea(start: lastTouchLocation,
                                end: pos,
                                size: selectNode.size,
                                areaNode: selectNode)
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
    }
    
}



/// 采矿操作区域选择
extension InputSystem {
    
    /// 按下
    func miningTouchdown(atPoint pos: CGPoint, scene: BaseScene) {
        lastTouchLocation = pos
        
        selectNode.removeFromParent()
        selectNode = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
        selectNode.anchorPoint = CGPoint(x: 0, y: 0)
        selectNode.zPosition = 100000
        selectNode.position = pos
        scene.addChild(selectNode)
    }
   
    /// 滑动
    func miningTouchMoved(atPoint pos: CGPoint, scene: BaseScene) {
        let xChange = pos.x - lastTouchLocation.x
        let yChange = pos.y - lastTouchLocation.y
        
        selectNode.xScale = xChange / 1
        selectNode.yScale = yChange / 1
        selectNode.alpha = 0.2
    
    }
    
    /// 抬起
    func miningTouchUp(atPoint pos: CGPoint, scene: BaseScene) {
        
        areaProvider.selectArea(start: lastTouchLocation,
                                end: pos,
                                size: selectNode.size,
                                areaNode: selectNode)
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
    }
    
}
