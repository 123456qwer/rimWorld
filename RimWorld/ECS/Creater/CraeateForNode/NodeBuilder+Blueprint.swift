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
        
        /// 先简单添加
        let node = RMBaseNode(color: .blue.withAlphaComponent(0.3), size: CGSize(width: blueComponent.width, height: blueComponent.height))
        node.position = CGPoint(x: blueComponent.tileX, y: blueComponent.tileY)
        return node
        
    }
    
}
