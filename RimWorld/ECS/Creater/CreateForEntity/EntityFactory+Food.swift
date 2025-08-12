//
//  EntityFactory+Food.swift
//  RimWorld
//
//  Created by wu on 2025/8/12.
//

import Foundation

extension EntityFactory {
    
    /// 生成可搬运的食物苹果
    func createApple(point:CGPoint,
                     params:WoodParams,
                     ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kApple
        
             
        let woodComponent = GoodsBasicInfoComponent()
        let woodName = "apple"
        woodComponent.textureName = woodName
        
        let haulComponent = HaulableComponent()
        haulComponent.weight = 1
        haulComponent.currentCount = params.woodCount

       
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        
        let foodComponent = FoodInfoComponent()

        
        entity.addComponent(foodComponent)
        entity.addComponent(pointComponent)
        entity.addComponent(woodComponent)
        entity.addComponent(haulComponent)

        
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
