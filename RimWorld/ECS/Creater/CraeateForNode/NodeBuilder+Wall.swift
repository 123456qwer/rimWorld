//
//  NodeBuilder+Wall.swift
//  RimWorld
//
//  Created by wu on 2025/7/25.
//

import Foundation
extension NodeBuilder {
    
    /// 创建蓝图
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
    
}
