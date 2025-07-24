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
                                       count:Int) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kWood
        
      

        let woodComponent = WoodBasicInfoComponent()
        let woodName = "wood"
        woodComponent.woodTexture = woodName
        
        let haulComponent = HaulableComponent()
        haulComponent.weight = 1
        haulComponent.currentCount = count

       
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        

        
        entity.addComponent(pointComponent)
        entity.addComponent(woodComponent)
        entity.addComponent(haulComponent)
        
        
        return entity
    }
    
}
