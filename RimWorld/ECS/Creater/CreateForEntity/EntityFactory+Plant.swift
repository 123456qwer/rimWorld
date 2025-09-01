//
//  EntityFactory+tree.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
extension EntityFactory {
    
    /// 水稻
    func createRice (point: CGPoint,
                     params: PlantParams,
                     ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kRice
        
        let treeComponent = PlantBasicInfoComponent()
        let treeName = ["apple"].randomElement()!
        treeComponent.plantTexture = treeName
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        let ownedComponent = OwnedComponent()
        ownedComponent.ownedEntityID = params.ownerId
        
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        entity.addComponent(ownedComponent)
        
        /// 设置在种植区域内
        let growArea = ecsManager.getEntity(params.ownerId)
        if let growComponent = growArea?.getComponent(ofType: GrowInfoComponent.self) {
            growComponent.saveEntities[params.saveKey] = entity.entityID
        }
        
        return entity
    }
    
}



