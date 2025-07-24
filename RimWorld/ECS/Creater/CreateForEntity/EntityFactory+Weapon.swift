//
//  EntityFactory+Weapon.swift
//  RimWorld
//
//  Created by wu on 2025/5/16.
//

import Foundation

extension EntityFactory{
    
    func michaelJordanForWeapon(_ entity:RMEntity) {
        
        /// 武器实体
        let weaponEntity = RMEntity()
        weaponEntity.type = kWeapon
        
        /// 位置
        let weaponPoint = PositionComponent()
        weaponPoint.x = 0
        weaponPoint.y = 0
        weaponPoint.z = 10
        
        /// 持有关系
        let owed = OwnedComponent()
        owed.ownedEntityID = entity.entityID
        
        /// 往人物实体中增加武器
        if let ownershipComponent = entity.getComponent(ofType: OwnershipComponent.self) {
            ownershipComponent.ownedEntityIDS.append(weaponEntity.entityID)
        }
        
        
        /// 这个狙击枪的拥有者是乔丹
        let weapon = WeaponComponent()
        weapon.textureName = "狙击枪"
        weapon.level = RimWorldEntityQuality.normal.rawValue
        
        
        addComponent([weapon,owed,weaponPoint], weaponEntity)

        
        saveEntity(entity: weaponEntity)
        
        

    }
    
}
