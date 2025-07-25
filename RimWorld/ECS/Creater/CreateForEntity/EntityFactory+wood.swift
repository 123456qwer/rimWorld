//
//  EntityFactory+wood.swift
//  RimWorld
//
//  Created by wu on 2025/6/30.
//

import Foundation

extension EntityFactory {
    
    /// 木头
    func wood (point:CGPoint)
    {
        let entity = RMEntity()
        entity.type = kWood
        
        let treeComponent = WoodBasicInfoComponent()
        let treeName = "wood"
        treeComponent.woodTexture = treeName
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        
        saveEntity(entity: entity)
    }
    
    
    func createWoodEntityWithoutSaving(point:CGPoint,
                                       params:WoodParams) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kWood
        
        /// 分类
        let categorizationComponent = CategorizationComponent()
        categorizationComponent.categorization = MaterialType.wood.rawValue

        
        let woodComponent = WoodBasicInfoComponent()
        let woodName = "wood"
        woodComponent.woodTexture = woodName
        
        let haulComponent = HaulableComponent()
        haulComponent.weight = 1
        haulComponent.currentCount = params.woodCount

       
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        

        
        entity.addComponent(pointComponent)
        entity.addComponent(woodComponent)
        entity.addComponent(haulComponent)
        entity.addComponent(categorizationComponent)
        
        
        return entity
    }
    
}
