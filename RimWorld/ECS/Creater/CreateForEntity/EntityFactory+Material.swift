//
//  EF+Material.swift
//  RimWorld
//
//  Created by wu on 2025/8/13.
//

import Foundation

/// 原材料
extension EntityFactory {
    
    /// 矿石
    func createOreEntityWithoutSaving(point:CGPoint,
                                      params:OreParams,
                                    ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kOre
        
        /// 分类
        let categorizationComponent = CategorizationComponent()
        categorizationComponent.categorization = params.materialType.rawValue

        
        let woodComponent = GoodsBasicInfoComponent()
        let woodName = "marble"
        woodComponent.textureName = woodName
        
        let haulComponent = HaulableComponent()
        haulComponent.weight = 1
        haulComponent.currentCount = params.oreCount

       
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
    
    /// 木头
    func createWoodEntityWithoutSaving(point:CGPoint,
                                       params:HarvestParams,
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
        haulComponent.currentCount = params.harvestCount

       
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
