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
        
        let treeComponent = GoodsBasicInfoComponent()
        let treeName = "wood"
        treeComponent.textureName = treeName
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        
        saveEntity(entity: entity)
    }
    
    
    func createWoodEntityWithoutSaving(point:CGPoint,
                                       params:WoodParams,
                                       ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kWood
        
        /// 分类
        let categorizationComponent = CategorizationComponent()
        categorizationComponent.categorization = MaterialType.wood.rawValue

        
        let woodComponent = GoodsBasicInfoComponent()
        let woodName = "wood"
        woodComponent.textureName = woodName
        
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
        
        /// 需要直接关联父实体
        if params.superEntity != -1 {
            
            let ownedComponent = OwnedComponent()
            ownedComponent.ownedEntityID = params.superEntity
            
            entity.addComponent(ownedComponent)
            
            /// 如果是仓库，记录下存储
            let storage = ecsManager.getEntity(params.superEntity)
            let storageComponent = storage?.getComponent(ofType: StorageInfoComponent.self)
            storageComponent?.saveEntities[params.saveIndex] = entity.entityID
        }
        
        
        
        return entity
    }
    
}
