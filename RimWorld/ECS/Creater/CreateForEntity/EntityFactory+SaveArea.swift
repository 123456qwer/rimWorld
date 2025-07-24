//
//  EntityFactory+SaveArea.swift
//  RimWorld
//
//  Created by wu on 2025/7/2.
//

import Foundation

extension EntityFactory {
 
    /// 创建存储区域
    func createSaveAreaEntityWithoutSaving(point:CGPoint,size:CGSize?) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kSaveArea
        
        let treeComponent = StorageInfoComponent()
        treeComponent.size = size ?? CGSize(width: 0, height: 0)
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = 100000
        
        let ownerShipComponent = OwnershipComponent()
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        entity.addComponent(ownerShipComponent)
        
        return entity
    }
    
}
