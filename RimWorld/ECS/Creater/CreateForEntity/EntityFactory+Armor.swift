//
//  EntityFactory+Armor.swift
//  RimWorld
//
//  Created by wu on 2025/5/16.
//

import Foundation
extension EntityFactory {
    
    func michaelJordanForArmor(_ entity:RMEntity) {
        
        let armorEntity = RMEntity()
        armorEntity.type = kArmor
        
        /// 装备
        let armor = ArmorComponent()
        
        
        /// 位置
        let point = PositionComponent()
        point.x = 0
        point.y = 0
        point.z = 10
        
        /// 持有关系
        let owed = OwnedComponent()
        owed.ownedEntityID = entity.entityID
        
        /// 往人物实体中增加武器
        if let ownershipComponent = entity.getComponent(ofType: OwnershipComponent.self) {
            ownershipComponent.ownedEntityIDS.append(armorEntity.entityID)
        }
        
        addComponent([armor,owed,point], armorEntity)
        saveEntity(entity: armorEntity)
        
    }
}
