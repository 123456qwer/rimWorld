//
//  EntityFactory+Blueprint.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
extension EntityFactory {
    
    func createBlueprint(point: CGPoint,
                         size: CGSize,
                         material: MaterialType) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kBlueprint
        
        let blueprintComponent = BlueprintComponent()
        blueprintComponent.tileX = Int(point.x)
        blueprintComponent.tileY = Int(point.y)
        blueprintComponent.materials = material.rawValue
        blueprintComponent.width = size.width
        blueprintComponent.height = size.height
        
        entity.addComponent(blueprintComponent)
        
        return entity
    }
    
}
