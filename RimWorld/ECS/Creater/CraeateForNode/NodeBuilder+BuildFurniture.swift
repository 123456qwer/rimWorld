//
//  NodeBuilder+BuildFurniture.swift
//  RimWorld
//
//  Created by wu on 2025/8/14.
//

import Foundation

/// 家具类
extension NodeBuilder {
    
    /// 灶台
    func stove(_ entity: RMEntity) -> RMBaseNode {
        
        guard let baseComponent = entity.getComponent(ofType: GoodsBasicInfoComponent.self),
              let positionComponent = entity.getComponent(ofType: PositionComponent.self) else {
            return RMBaseNode()
        }
        
        /// 先简单添加
        let node = RMBaseNode(texture: TextureManager.shared.getTexture(baseComponent.textureName), color: .red, size: CGSize(width: tileSize * 2.0, height: tileSize))
        node.position = CGPoint(x: positionComponent.x, y: positionComponent.y)
        node.zRotation = EntityInfoTool.getZRotation(entity: entity)
        return node
    }
    
}
