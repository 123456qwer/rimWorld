//
//  EntityNodeActionTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation
import SpriteKit

//MARK: - 💀 实体Node相关的操作 💀 -
/// 实体Node相关的操作
struct EntityNodeTool {
    
    /// 更新数量Node
    static func updateHaulCountLabel(entity: RMEntity,
                                     count: Int) {
        guard let labelNode = entity.node?.childNode(withName: "haulCount") as? SKLabelNode else { return }
        labelNode.text = "\(count)"
    }
    /// 砍伐完成
    static func cuttingFinish(targetNode: RMBaseNode) {
        targetNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.3),SKAction.removeFromParent()]))
    }
    
    /// 停止砍树
    static func stopCuttingAnimation(entity: RMEntity) {
        guard let targetNode = entity.node else {
            ECSLogger.log("强制停止砍伐失败，没有找到对应的Node：\(entity.name)💀💀💀")
            return
        }
        
        let picking = targetNode.childNode(withName: "pickHand")
        let cutting = targetNode.childNode(withName: "cutting")
        cutting?.removeFromParent()
        picking?.removeFromParent()
        targetNode.progressBar.isHidden = true
    }
    
    /// 停止建造
    static func stopBuildingAnimation(entity: RMEntity) {
        guard let targetNode = entity.node else {
            ECSLogger.log("强制停止建造失败，没有找到对应的Node：\(entity.name)💀💀💀")
            return
        }
        
        let building = targetNode.childNode(withName: "building")
        building?.removeFromParent()
        targetNode.progressBar.isHidden = true
    }
    
    /// 休息
    static func sleepingAniamtion(entity: RMEntity,
                              tick: Int) {
        guard let executorNode = entity.node else { return }
        
        if executorNode.zLabel.parent == nil { executorNode.addChild(executorNode.zLabel) }
        executorNode.zLabel.isHidden = false
        
        let alpha = executorNode.zLabel.alpha - 0.01 * Double(tick)
        let x = executorNode.zLabel.position.x + CGFloat.random(in: 0.1...0.7) * Double(tick)
        let y = executorNode.zLabel.position.y + CGFloat.random(in: 0.1...0.7) * Double(tick)
        executorNode.zLabel.alpha = alpha
        executorNode.zLabel.position = CGPoint(x: x, y: y)
        
        if executorNode.zLabel.alpha <= 0 {
            executorNode.zLabel.alpha = 1
            executorNode.zLabel.position = CGPoint(x: 0, y: 0)
        }
    }
    
    /// 停止休息
    static func endSleepingAnimation(entity: RMEntity){
        guard let executorNode = entity.node else { return }
        executorNode.zLabel.isHidden = true
    }
}
