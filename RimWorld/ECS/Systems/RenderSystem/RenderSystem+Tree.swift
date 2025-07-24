//
//  RenderSystem+Tree.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import SpriteKit

extension RenderSystem {
    
    /// 根据树的状态（canChop）添加或移除斧头标志
    func treeStatusChange(_ entity: RMEntity,
                          canChop: Bool) {
        
        guard let treeNode = entity.node else { return }
        
        let axeNodeName = "axeChop"
        let existingAxeNode = treeNode.childNode(withName: axeNodeName)
        
        guard let treeInfo = entity.getComponent(ofType: PlantBasicInfoComponent.self) else { return }

        if canChop {
            // 添加斧头节点（如果不存在）
            if existingAxeNode == nil {
                let axe = SKSpriteNode(
                    texture: TextureManager.shared.getTexture("chopIcon"),
                    color: .clear,
                    size: CGSize(width: tileSize * 1.5, height: tileSize * 1.5)
                )
                axe.name = axeNodeName
                axe.position = CGPoint(x: 0, y: 0) // 可自定义位置
                axe.zPosition = 4
                treeNode.addChild(axe)
            }
        } else {
            // 移除已有斧头节点
            existingAxeNode?.removeFromParent()
        }
    }
    

}
