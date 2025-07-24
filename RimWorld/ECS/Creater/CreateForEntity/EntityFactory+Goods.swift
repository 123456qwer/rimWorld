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
    
}
