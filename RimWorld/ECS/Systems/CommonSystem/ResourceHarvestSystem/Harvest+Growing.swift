//
//  Harvest+Growing.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 移除种植区域
extension ResourceHarvestSystem {
    
    func removeGrowing(reason: GrowingAreaRemoveReason) {
        
        let targetEntity = reason.entity
        
        guard let growComponent = targetEntity.getComponent(ofType: GrowInfoComponent.self) else { return }
        
        let allEntities = growComponent.saveEntities
        let growPoint = PositionTool.nowPosition(targetEntity)
        let points = PositionTool.getAreaAllPoints(size: growComponent.size)
        
        /// 将子视图坐标转换成父视图坐标
        for (index,cropID) in allEntities {
            let cropEntity = ecsManager.getEntity(cropID) ?? RMEntity()
            let cropPoint = points[index]
            let pointForScene = CGPoint(x: growPoint.x + cropPoint.x, y: growPoint.y + cropPoint.y)
            PositionTool.setPosition(entity:cropEntity, point: pointForScene)
            OwnerShipTool.removeOwner(owned: cropEntity, ecsManager: ecsManager)
            cropEntity.removeComponent(ofType: OwnedComponent.self)
            
            RMEventBus.shared.requestReparentEntity(entity: cropEntity, z: 0, point: pointForScene)
        }
    }
    
}
