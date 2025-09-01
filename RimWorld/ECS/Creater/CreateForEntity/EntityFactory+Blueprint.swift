//
//  EntityFactory+Blueprint.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
extension EntityFactory {
    
    /// 创建蓝图
    func createBlueprint(point: CGPoint,
                         params: BlueprintParams) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kBlueprint
        
        let blueprintComponent = BlueprintComponent()
        blueprintComponent.tileX = Int(point.x)
        blueprintComponent.tileY = Int(point.y)
        blueprintComponent.materials = params.materials
        blueprintComponent.blueprintType = params.type.rawValue
        blueprintComponent.totalBuildPoints = params.totalBuildPoint
        blueprintComponent.textureName = params.textureName
        blueprintComponent.anchorX = params.anchorPoint.x
        blueprintComponent.anchorY = params.anchorPoint.y
        blueprintComponent.blueMaterial = params.material.rawValue
        
        let ownerComponent = OwnershipComponent()
        
        let positionComponent = PositionComponent()
        positionComponent.x = point.x
        positionComponent.y = point.y
        
        
        var alreadyMaterials:[String:Int] = [:]
        for (key,_) in params.materials {
            alreadyMaterials[key] = 0
        }
        blueprintComponent.alreadyMaterials = alreadyMaterials
        
        blueprintComponent.width = params.size.width
        blueprintComponent.height = params.size.height
        
        let directionComponent = DirectionComponent()
        
        entity.addComponent(blueprintComponent)
        entity.addComponent(positionComponent)
        entity.addComponent(ownerComponent)
        entity.addComponent(directionComponent)

        return entity
    }
    
}
