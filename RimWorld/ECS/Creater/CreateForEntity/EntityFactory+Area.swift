//
//  EntityFactory+Area.swift
//  RimWorld
//
//  Created by wu on 2025/8/13.
//

import Foundation

/// 区域
extension EntityFactory {
 
    /// 创建存储区域
    func createSaveAreaEntityWithoutSaving(point:CGPoint,
                                           params: StorageParams) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kStorageArea
        
        let treeComponent = StorageInfoComponent()
        treeComponent.size = params.size
        
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
    
    /// 创建种植区域，默认稻米
    func createGrowingArea(point:CGPoint,
                           params:GrowingParams) -> RMEntity {
        let entity = RMEntity()
        entity.type = kGrowingArea
        
        let areaComponent = GrowInfoComponent()
        areaComponent.size = params.size
        areaComponent.cropType = params.cropType.rawValue
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = 100000
        
        let ownerShipComponent = OwnershipComponent()
        
        entity.addComponent(pointComponent)
        entity.addComponent(areaComponent)
        entity.addComponent(ownerShipComponent)
        
        return entity
    }
}
