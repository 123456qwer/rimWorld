//
//  NodeBuilder+Weapon.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import SpriteKit

extension NodeBuilder {
    
    
    /// 创建武器Node
    func buildWeapon(_ entity:RMEntity) -> RMBaseNode {
        
        if let weaponComponent = entity.getComponent(ofType: WeaponComponent.self),
           let pointComponent = entity.getComponent(ofType: PositionComponent.self){
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(weaponComponent.textureName))
            node.name = weaponComponent.textureName
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
            return node
        }
        
        return RMBaseNode()
    }
}
