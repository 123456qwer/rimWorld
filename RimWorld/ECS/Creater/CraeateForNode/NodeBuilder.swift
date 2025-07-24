//
//  NodeBuilder.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import SpriteKit

final class NodeBuilder: NSObject {
    
    /// 方法映射表
    lazy var selMap:[String: (RMEntity) -> RMBaseNode] = [
        
        kCharacter: buildCharacter,
        kWeapon: buildWeapon,
        kTree:buildTree,
        kWood:buildWood,
        kSaveArea:saveArea,
        kBlueprint:blueprint,
    ]
    
    /// 根据类型创建Node
    func buildNode(for entity: RMEntity) -> RMBaseNode {
        return selMap[entity.type]?(entity) ?? RMBaseNode()
    }
 
}
