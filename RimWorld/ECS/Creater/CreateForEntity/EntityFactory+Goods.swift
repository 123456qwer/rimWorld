//
//  EntityFactory+Goods.swift
//  RimWorld
//
//  Created by wu on 2025/5/16.
//

import Foundation
extension EntityFactory {
    
    
    func yueFeiForGoods(_ entity:RMEntity){
        
        let medicineEntity = RMEntity()
        medicineEntity.type = kMedicine
        
        /// 医药
        let medicineComponent = MedicalKitComponent()

        /// 持有关系
        let owed = OwnedComponent()
        owed.ownedEntityID = entity.entityID
        
        /// 往人物实体中增加关联物品
        if let ownershipComponent = entity.getComponent(ofType: OwnershipComponent.self) {
            ownershipComponent.ownedEntityIDS.append(medicineEntity.entityID)
        }
        
        addComponent([medicineComponent,owed], medicineEntity)
        saveEntity(entity: medicineEntity)
    }
    
    
    func stone(point: CGPoint) {
        
        let entity = RMEntity()
        entity.type = kStone
        
        let blockComponent = MovementBlockerComponent()
        let miningComponent = MiningComponent()
        miningComponent.miningTexture = "stone"
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        entity.addComponent(pointComponent)
        entity.addComponent(blockComponent)
        entity.addComponent(miningComponent)

        
        saveEntity(entity: entity)
    }
    
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
    
    
}
