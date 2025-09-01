//
//  NodeBuilder+BuildStructure.swift
//  RimWorld
//
//  Created by wu on 2025/8/14.
//

import Foundation

/// 建筑类
extension NodeBuilder {
    
    
    /// 创建墙
    func woodWall(_ entity: RMEntity) -> RMBaseNode {
        guard let wallComponent = entity.getComponent(ofType: WallComponent.self),
              let positionComponent = entity.getComponent(ofType: PositionComponent.self) else {
            return RMBaseNode()
        }
        
        /// 先简单添加
        let node = RMBaseNode(texture: TextureManager.shared.getTexture(wallComponent.textureName), color: .red, size: CGSize(width: wallComponent.width, height: wallComponent.height))
        node.position = CGPoint(x: positionComponent.x, y: positionComponent.y)
        return node
        
    }
    
    
    func ore(_ entity: RMEntity) -> RMBaseNode {
        guard let baseComponent = entity.getComponent(ofType: GoodsBasicInfoComponent.self),
              let positionComponent = entity.getComponent(ofType: PositionComponent.self) else {
            return RMBaseNode()
        }
        
        /// 先简单添加
        let node = RMBaseNode(texture: TextureManager.shared.getTexture(baseComponent.textureName), color: .red, size: CGSize(width: tileSize, height: tileSize))
        node.position = CGPoint(x: positionComponent.x, y: positionComponent.y)
        return node
        
    }
    
}
