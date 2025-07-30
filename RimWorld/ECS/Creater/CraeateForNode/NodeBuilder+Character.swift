//
//  NodeBuilder+Character.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import SpriteKit

extension NodeBuilder {
    
    /// 创建人物Node
    func buildCharacter(_ entity:RMEntity) -> RMBaseNode {
        
        if let basicComponent = entity.getComponent(ofType: BasicInfoComponent.self),
           let pointComponent = entity.getComponent(ofType: PositionComponent.self){
            let node = RMBaseNode(color: UIColor.randomColor(), size: CGSize(width: 64, height: 64))
            node.texture = TextureManager.shared.getTexture(basicComponent.textureName)
            node.name = basicComponent.textureName
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
            return node
        }
        
        return RMBaseNode()
    }
}
