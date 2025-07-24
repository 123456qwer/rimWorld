//
//  EntityFactory+tree.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
extension EntityFactory {
    
    /// 树
    func tree (point:CGPoint)
    {
        let entity = RMEntity()
        entity.type = kTree
        
        let treeComponent = PlantBasicInfoComponent()
        let treeName = ["tree1","tree2","tree3"].randomElement()!
        treeComponent.plantTexture = treeName
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        
        saveEntity(entity: entity)
    }
    
}
