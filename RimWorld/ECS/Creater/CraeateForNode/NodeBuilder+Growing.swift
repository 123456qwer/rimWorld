//
//  NodeBuilder+Growing.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation

extension NodeBuilder {
    
    func growing(_ entity: RMEntity) -> RMBaseNode {
        
        guard let pointComponent = entity.getComponent(ofType: PositionComponent.self),
              let basicComponent = entity.getComponent(ofType: GrowInfoComponent.self) else {
            return RMBaseNode()
        }
        
        let node = RMBaseNode(color: .white.withAlphaComponent(0.3), size: CGSize(width: 1, height: 1))
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
        node.size = basicComponent.size
        node.name = "saveArea"
        node.zPosition = 10000
        return node
    }
    
}
