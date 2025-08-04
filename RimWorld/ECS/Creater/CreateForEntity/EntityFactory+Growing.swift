//
//  EntityFactory+Growing.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation

extension EntityFactory {
    
    /// 创建种植区域，默认稻米
    func createGrowingArea(point:CGPoint,
                           params:GrowingParams) -> RMEntity {
        let entity = RMEntity()
        entity.type = kGrowingArea
        
        let areaComponent = GrowInfoComponent()
        areaComponent.size = params.size
        areaComponent.type = params.cropType.rawValue
        
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
