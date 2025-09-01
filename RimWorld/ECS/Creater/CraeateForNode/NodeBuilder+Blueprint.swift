//
//  NodeBuilder+Blueprint.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
extension NodeBuilder {
    
    /// 创建蓝图
    func blueprint(_ entity: RMEntity) -> RMBaseNode {
        guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
            return RMBaseNode()
        }
        

        let textureName = blueComponent.textureName
        
        
        
        /// 先简单添加
        let node = RMBaseNode(color: .blue.withAlphaComponent(0.3), size: CGSize(width: blueComponent.width, height: blueComponent.height))
        node.texture = TextureManager.shared.getTexture(textureName)
        node.position = CGPoint(x: blueComponent.tileX, y: blueComponent.tileY)
        node.alpha = 0.3
        

        node.anchorPoint = CGPoint(x: blueComponent.anchorX, y: blueComponent.anchorY)
        
        
        var isSubMaterial = false
        for (_,count) in blueComponent.alreadyMaterials {
            if count != 0 {
                isSubMaterial = true
                break
            }
        }
        
        /// 如果有，说明是在建状态，改变下
        if isSubMaterial {
            node.texture = TextureManager.shared.getTexture("bluePrint2")
            node.alpha = 1
        }
        
        return node
        
    }
    
}
